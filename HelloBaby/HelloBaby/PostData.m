//
//  PostData.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/10.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "PostData.h"
#import "UserData.h"

@implementation CommentData

@end

@implementation PostData

@end

@implementation PostDataRequest

NSString* kServerURL = @"http://localhost:3000";

-(void) requestPostsAboutBaby:(NSInteger)id pageNum:(NSInteger)num updateHandler:(update_handler_t)handler
{
    // async request
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* url = [NSString stringWithFormat:@"%@/babies/%ld/posts?num=%ld", kServerURL, id, num];
        NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
        NSHTTPURLResponse *response;
        NSError *error;
        // request
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"REQUEST failed: %@", url);
            return;
        }
        // parse
        _postDataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"JSON parse failed: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return;
        }
        
        // request img
        dispatch_group_t group = dispatch_group_create();
        for (NSDictionary* item in _postDataArray) {
            NSString* imgPath = [item valueForKey:@"img"];
            dispatch_group_async(group, queue, ^{
                NSString* url = [NSString stringWithFormat:@"%@/%@", kServerURL, imgPath];
                NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
                NSHTTPURLResponse *response;
                NSError *error;
                // request
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                if (error) {
                    NSLog(@"REQUEST IMG failed: %@", imgPath);
                }
                [item setValue:[UIImage imageWithData:data] forKey:@"imgData"];
            });
        }
        // wait until done
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        // prepare PostData
        NSMutableArray* postDataArray = [[NSMutableArray alloc] init];
        for (NSDictionary* item in _postDataArray)  {
            PostData* data = [[PostData alloc] init];
            data.postMsg = [item valueForKey:@"content"];
            data.postImage = [item valueForKey:@"imgData"];
            data.commentArray = [[NSMutableArray alloc] init];
            for (NSDictionary* commentItem in [item valueForKey:@"comments"]) {
                CommentData* commentData = [[CommentData alloc] init];
                commentData.username = [commentItem valueForKey:@"username"];
                commentData.content = [commentItem valueForKey:@"content"];
                [data.commentArray addObject:commentData];
            }
            RelationshipType relationshipType = [[item valueForKey:@"relationship"] integerValue];
            data.postStatus = [UserData getRelationshipName:relationshipType];
            data.likeNum = [[item valueForKey:@"goodNum"] integerValue];
            //
            [postDataArray addObject:data];
        }
        
        // run block
        handler(postDataArray);
        
        // clear
        _postDataArray = nil;
    });
}

@end