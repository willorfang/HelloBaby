//
//  BabyData.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/07.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyData : NSObject

@property (nonatomic) NSInteger id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSDate* birthday;
@property (strong, nonatomic) NSData* avatar;
@property (strong, nonatomic) NSData* background;
@property (strong, nonatomic) NSString* status;

@end
