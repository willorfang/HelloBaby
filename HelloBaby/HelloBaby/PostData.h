//
//  PostData.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/10.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PostData : NSObject

@property (strong, nonatomic) NSString* postMsg;
@property (strong, nonatomic) UIImage* postImage;
@property (strong, nonatomic) NSString* postStatus;
@property (strong, nonatomic) NSArray* commentArray;
@property NSInteger likeNum;

@end
