//
//  UserData.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/05.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RelationshipType) {
    kRelationshipMom = 1,
    kRelationshipDad = 2,
    kRelationshipUncle = 3,
    kRelationshipAunt = 4
};

@interface UserData : NSObject

+(NSString*) getRelationshipName:(RelationshipType)type;

@end
