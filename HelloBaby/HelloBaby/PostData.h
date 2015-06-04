//
//  PostData.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/10.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentData : NSObject

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* content;

@end

@interface PostData : NSObject

@property (strong, nonatomic) NSString* postMsg;
@property (strong, nonatomic) UIImage* postImage;
@property (strong, nonatomic) NSString* postStatus;
@property (strong, nonatomic) NSMutableArray* commentArray;
@property NSInteger likeNum;

@end

typedef void (^update_handler_t)(NSMutableArray*);

@interface PostDataRequest : NSObject {
    // response JSON data
    NSMutableArray* _postDataArray;
}

- (void) requestPostsAboutBaby:(NSInteger)id pageNum:(NSInteger)num updateHandler:(update_handler_t)handler;

@end
