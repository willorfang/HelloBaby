//
//  PostData.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/10.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "PostData.h"
#import "UserData.h"

@implementation CommentDataForPost

@end

@implementation CommentDataForShow

@end

@implementation PostData

-(NSString*) getStatusString
{
    NSString* relationship = [UserData getRelationshipName:self.relationship];
    return [NSString stringWithFormat:@"%@  %@", relationship, self.postTime];
}

+(NSString*) getTimeFromUTC:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate* date = [dateFormatter dateFromString:time];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

@end

@implementation PostDataRequest

static NSString* kServerURL = @"http://localhost:3000";

-(void) requestPostsAboutBaby:(NSInteger)baby_id
                      pageNum:(NSInteger)num
                updateHandler:(update_handler_t)handler
{
    //
    NSString* url = [NSString stringWithFormat:@"%@/babies/%ld/posts?num=%ld", kServerURL, baby_id, num];
    [URLRequest getFromURL:url WithJson:nil completeHandler:^(BOOL succeed, id postData) {
        if (!succeed) {
            NSLog(@"REQUEST failed: %@", url);
            return;
        }

        _postDataArray = (NSMutableArray*)postData;
        
        // request img
        dispatch_group_t group = dispatch_group_create();
        for (NSMutableDictionary* item in _postDataArray) {
            NSString* imgPath = [item valueForKey:@"img"];
            NSString* url = [NSString stringWithFormat:@"%@/%@", kServerURL, imgPath];
            [URLRequest getFromURLDirectly:url WithJson:nil WithGroup:group completeHandler:^(id imgData) {
                [item setValue:[UIImage imageWithData:imgData] forKey:@"imgData"];
            }];
        }
        
        // wait until the last
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        //
        {
            // prepare PostData
            NSMutableArray* postDataArray = [[NSMutableArray alloc] init];
            for (NSMutableDictionary* item in _postDataArray)  {
                PostData* data = [[PostData alloc] init];
                id postMsg = [item objectForKey:@"content"];
                if (postMsg != [NSNull null]) {
                    data.postMsg = postMsg;
                }
                id postImage = [item valueForKey:@"imgData"];
                if (postImage != [NSNull null]) {
                    data.postImage = postImage;
                }
                data.commentArray = [[NSMutableArray alloc] init];
                for (NSDictionary* commentItem in [item valueForKey:@"comments"]) {
                    CommentDataForShow* commentData = [[CommentDataForShow alloc] init];
                    commentData.username = [commentItem valueForKey:@"username"];
                    commentData.content = [commentItem valueForKey:@"content"];
                    [data.commentArray addObject:commentData];
                }
                data.relationship = [[item valueForKey:@"relationship"] integerValue];
                data.postTime = [PostData getTimeFromUTC:[item valueForKey:@"time"]];
                data.likeNum = [[item valueForKey:@"goodNum"] integerValue];
                data.postID = [[item valueForKey:@"id"] integerValue];
                //
                [postDataArray addObject:data];
            }
            
            // run block
            handler(postDataArray);
            
            // clear
            _postDataArray = nil;
        }
    }];
}

- (void) postAboutBaby:(NSInteger)baby_id
                byUser:(NSInteger)user_id
           withMessage:(NSString *)msg
              AndImage:(UIImage *)image
                atTime:(NSString*)timestamp
       completeHandler:(request_handler_t)handler
{
    NSString* url = [NSString stringWithFormat:@"%@/posts", kServerURL];
    NSDictionary* dictData = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInteger:baby_id], @"record[baby_id]",
                              [NSNumber numberWithInteger:user_id], @"record[poster_id]",
                              timestamp, @"record[time]",
                              msg, @"record[content]",
                              nil];
    NSDictionary* dictImageName = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"baby-%ld.jpg", baby_id], @"img",
                                   nil];
    NSDictionary* dictImageData = [NSDictionary dictionaryWithObjectsAndKeys:
                                   image, @"img",
                                   nil];
    [URLRequest postToURL:url WithDataForm:dictData ImageName:dictImageName ImageData:dictImageData completeHandler:handler];
}

-(void) addCommentToPost:(NSInteger)record_id
                  byUser:(NSInteger)user_id
             withMessage:(NSString*)content
         completeHandler:(request_handler_t)handler
{

    NSString* url = [NSString stringWithFormat:@"%@/comments", kServerURL];
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInteger:record_id],
                                                               [NSNumber numberWithInteger:user_id],
                                                               content]
                                                     forKeys:@[@"record_id", @"poster_id", @"content"]];
    [URLRequest postToURL:url WithJson:dict completeHandler:handler];
}

-(void) addGoodToPost:(NSInteger)record_id
               byUser:(NSInteger)user_id
      completeHandler:(request_handler_t)handler
{
    NSString* url = [NSString stringWithFormat:@"%@/goods", kServerURL];
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInteger:record_id],
                                                               [NSNumber numberWithInteger:user_id]]
                                                     forKeys:@[@"record_id", @"poster_id"]];
    [URLRequest postToURL:url WithJson:dict completeHandler:handler];
}

@end