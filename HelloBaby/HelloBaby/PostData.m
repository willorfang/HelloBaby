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
    // async request
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* url = [NSString stringWithFormat:@"%@/babies/%ld/posts?num=%ld", kServerURL, baby_id, num];
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
            NSString* postMsg = [item objectForKey:@"content"];
            if (postMsg != [NSNull null]) {
                data.postMsg = postMsg;
            }
            UIImage* postImage = [item valueForKey:@"imgData"];
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
    });
}

- (void) postAboutBaby:(NSInteger)baby_id
                byUser:(NSInteger)user_id
           withMessage:(NSString *)msg
              AndImage:(UIImage *)image
                atTime:(NSString*)timestamp
       completeHandler:(empty_handler_t)handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* url = [NSString stringWithFormat:@"%@/posts", kServerURL];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
        [request setHTTPMethod:@"POST"];
        // set form information
        NSString *boundary = @"----------------------------6a31e72a8c4c";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        //set body
        NSMutableData *body = [NSMutableData data];
        // baby_id
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"record[baby_id]\"\r\n\r\n%ld", baby_id] dataUsingEncoding:NSUTF8StringEncoding]];
        // poster_id
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"record[poster_id]\"\r\n\r\n%ld", user_id] dataUsingEncoding:NSUTF8StringEncoding]];
        // time
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"record[time]\"\r\n\r\n%@", timestamp] dataUsingEncoding:NSUTF8StringEncoding]];
        // msg
        if (msg) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"record[content]\"\r\n\r\n%@", msg] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        // image
        if (image) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"img\"; filename=\"baby-%ld.jpg\"\r\n", baby_id] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)]];
        }
        // end
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        [request setHTTPBody:body];
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%ld", [body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        NSLog(@"Request: %@", request);
        NSLog(@"Body info: %@", [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
        
        // do request
        NSHTTPURLResponse *response;
        NSError *error;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"REQUEST failed: %@", url);
            return;
        }
        
        // complete handler
        handler();
    });

}

-(void) addCommentToPost:(NSInteger)record_id
                  byUser:(NSInteger)user_id
             withMessage:(NSString*)content
         completeHandler:(empty_handler_t)handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* url = [NSString stringWithFormat:@"%@/comments", kServerURL];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
        [request setHTTPMethod:@"POST"];
        NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInteger:record_id],
                                                                   [NSNumber numberWithInteger:user_id],
                                                                   content]
                                                         forKeys:@[@"record_id", @"poster_id", @"content"]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error;
        NSData* body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        [request setHTTPBody:body];
        
        NSHTTPURLResponse *response;
        // request
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"REQUEST failed: %@", url);
            return;
        }
        
        // complete handler
        handler();
    });
}

@end