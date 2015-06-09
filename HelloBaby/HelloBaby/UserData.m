//
//  UserData.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/05.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "UserData.h"

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
        
        // request user data
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_async(group, queue, ^{
            NSString* url = [NSString stringWithFormat:@"%@/users/1", kServerURL];
            NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
            NSHTTPURLResponse *response;
            NSError *error;
            // request
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (error) {
                NSLog(@"REQUEST failed: %@", url);
                return;
            }
            // parse json
            NSDictionary* dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"JSON parse failed: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                return;
            }
            // init
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
                NSString* avatar = [babyDictData valueForKey:@"avatar"];
                if (avatar) {
                    dispatch_group_async(group, queue, ^{
                        NSString* url = [NSString stringWithFormat:@"%@/%@", kServerURL, avatar];
                        NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
                        NSHTTPURLResponse *response;
                        NSError *error;
                        // request
                        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                        if (error) {
                            NSLog(@"REQUEST IMG failed: %@", avatar);
                        } else {
                            baby.avatar = data;
                        }
                    });
                }
                //
                NSString* background = [babyDictData valueForKey:@"background"];
                if (background) {
                    dispatch_group_async(group, queue, ^{
                        NSString* url = [NSString stringWithFormat:@"%@/%@", kServerURL, background];
                        NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
                        NSHTTPURLResponse *response;
                        NSError *error;
                        // request
                        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                        if (error) {
                            NSLog(@"REQUEST IMG failed: %@", avatar);
                        } else {
                            baby.background = data;
                        }
                    });
                }
                //
                baby.status = [babyDictData valueForKey:@"status"];
                
                //
                sharedInstance.baby = baby;
            }
        });
        
        // wait until done
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    });
    
    return sharedInstance;
}

@end
