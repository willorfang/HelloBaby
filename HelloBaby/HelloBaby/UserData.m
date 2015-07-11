//
//  UserData.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/05.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "UserData.h"
#import "URLRequest.h"

NSString* kNotificationLogined = @"Logined";

@implementation UserData

static UserData *sharedInstance = nil;

-(NSString*) getRelationshipName
{
    return [UserData getRelationshipName:self.relationship];
}

-(NSString*) getIdentityName
{
    return [NSString stringWithFormat:@"%@@%@", self.baby.name, [self getRelationshipName]];
}

+(NSString*) getRelationshipName:(RelationshipType)type
{
    NSString* name = nil;
    switch (type) {
        case kRelationshipMom:
            name = @"妈妈";
            break;
        case kRelationshipDad:
            name = @"爸爸";
            break;
        case kRelationshipUncle:
            name = @"叔叔";
            break;
        case kRelationshipAunt:
            name = @"阿姨";
            break;
        default:
            name = @"未知";
            break;
    }
    return name;
}

+(NSDate*) getDateFromUTC:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [dateFormatter dateFromString:time];
}

static NSString* kServerURL = @"http://localhost:3000";

+(UserData*) sharedUser
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+(BOOL) loginWithName:(NSString*)username password:(NSString*)password completeHandler:(login_handler_t)handler
{
    [UserData sharedUser];
    
    // login
    NSString* url = [NSString stringWithFormat:@"%@/login", kServerURL];
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[username, password]
                                                     forKeys:@[@"username", @"password"]];
    [URLRequest postToURL:url WithJson:dict completeHandler:^(BOOL succeed, id dictData) {
        if (!succeed) {
            NSLog(@"JSON parse failed: %@", [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding]);
            return;
        }
        // init user data
        sharedInstance.user_id = [[dictData valueForKey:@"id"] integerValue];
        sharedInstance.username = [dictData valueForKey:@"username"];
        sharedInstance.relationship = [[dictData valueForKey:@"relationship"] integerValue];
        {
            BabyData* baby = [[BabyData alloc] init];
            //
            NSDictionary* babyDictData = [dictData valueForKey:@"baby"];
            //
            baby.id = [[babyDictData valueForKey:@"id"] integerValue];
            //
            baby.name = [babyDictData valueForKey:@"name"];
            //
            NSString* birthday = [babyDictData valueForKey:@"birthday"];
            baby.birthday = [UserData getDateFromUTC:birthday];
            //
            baby.status = [babyDictData valueForKey:@"status"];
            //
            sharedInstance.baby = baby;
            
            // load images if any
            dispatch_group_t group = dispatch_group_create();
            //
            id avatar = [babyDictData valueForKey:@"avatar"];
            if (avatar != [NSNull null]) {
                //
                NSString* url = [NSString stringWithFormat:@"%@/%@", kServerURL, avatar];
                [URLRequest getFromURLDirectly:url WithJson:nil  WithGroup:group completeHandler:^(id avatarData) {
                    baby.avatar = avatarData;
                }];
            }
            //
            id background = [babyDictData valueForKey:@"background"];
            if (background != [NSNull null]) {
                //
                NSString* url = [NSString stringWithFormat:@"%@/%@", kServerURL, background];
                [URLRequest getFromURLDirectly:url WithJson:nil WithGroup:group completeHandler:^(id backgroundData) {
                    baby.background = backgroundData;
                }];
            }
            
            // wait until all loaded
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            NSLog(@"User logined");
            
            if (handler) {
                handler();
            }
        }
    }];
    
    return TRUE;
}

@end
