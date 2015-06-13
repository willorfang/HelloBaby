//
//  UserData.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/05.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyData.h"

typedef NS_ENUM(NSUInteger, RelationshipType) {
    kRelationshipMom = 1,
    kRelationshipDad = 2,
    kRelationshipUncle = 3,
    kRelationshipAunt = 4
};

@interface UserData : NSObject

@property NSInteger user_id;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) BabyData* baby;
@property NSInteger relationship;

-(NSString*) getRelationshipName;
-(NSString*) getIdentityName;
+(NSString*) getRelationshipName:(RelationshipType)type;
+(NSDate*) getDateFromUTC:(NSString*)time;
+(UserData*) sharedUser;
+(BOOL) loginWithName:(NSString*)username password:(NSString*)password;
@end
