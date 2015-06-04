//
//  UserData.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/05.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "UserData.h"

@implementation UserData

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

@end
