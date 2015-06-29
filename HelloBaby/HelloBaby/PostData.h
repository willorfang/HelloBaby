//
//  PostData.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/10.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentDataForPost : NSObject

@property (nonatomic) NSInteger record_id;
@property (nonatomic) NSInteger poster_id;
@property (nonatomic) NSInteger order;
@property (strong, nonatomic) NSString* content;

@end

@interface CommentDataForShow : NSObject

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* content;

@end

@interface PostData : NSObject

@property (nonatomic) NSInteger postID;
@property (strong, nonatomic) NSString* postMsg;
@property (strong, nonatomic) UIImage* postImage;
@property NSInteger relationship;
@property (strong, nonatomic) NSString* postTime;
@property (strong, nonatomic) NSMutableArray* commentArray;
@property NSInteger likeNum;

-(NSString*) getStatusString;
+(NSString*) getTimeFromUTC:(NSString*)time;

@end

typedef void (^update_handler_t)(NSMutableArray*);
typedef void (^empty_handler_t)();

@interface PostDataRequest : NSObject {
    // response JSON data
    NSMutableArray* _postDataArray;
}

-(void) requestPostsAboutBaby:(NSInteger)baby_id
                       pageNum:(NSInteger)num
                 updateHandler:(update_handler_t)handler;

-(void) postAboutBaby:(NSInteger)baby_id
                byUser:(NSInteger)user_id
           withMessage:(NSString*)msg
              AndImage:(UIImage*)image
                atTime:(NSString*)timestamp
       completeHandler:(empty_handler_t)handler;

-(void) addCommentToPost:(NSInteger)record_id
                  byUser:(NSInteger)user_id
             withMessage:(NSString*)content
         completeHandler:(empty_handler_t)handler;


@end
