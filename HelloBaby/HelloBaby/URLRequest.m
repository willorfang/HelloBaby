//
//  URLRequest.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/07/01.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//
#include <UIKit/UIKit.h>
#import "URLRequest.h"

static NSString* kRequestMethodPost = @"POST";

@interface URLRequest ()

+(void) requestToURL:(NSString*)url
          WithMethod:(NSString*)method
            WithJson:(NSDictionary*)dict
           WithGroup:(dispatch_group_t)group
     completeHandler:(request_handler_t)handler;

+(void) requestToURLDirectly:(NSString*)url
                  WithMethod:(NSString*)method
                    WithJson:(NSDictionary*)dict
                   WithGroup:(dispatch_group_t)group
             completeHandler:(result_handler_t)handler;

@end

@implementation URLRequest

+(void) requestToURLDirectly:(NSString*)url
                  WithMethod:(NSString*)method
                    WithJson:(NSDictionary*)dict
                   WithGroup:(dispatch_group_t)group
             completeHandler:(result_handler_t)handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
        
        if (method != nil) {
            [request setHTTPMethod:method];
        }
        if (dict != nil) {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSData* body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
            [request setHTTPBody:body];
        }
        
        NSError *error;
        NSHTTPURLResponse *response;
        // request
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"REQUEST failed: %@", url);
            return;
        }
        
        // complete handler
        if (handler) {
            handler(data);
        }
    });
}

+(void) requestToURL:(NSString*)url
          WithMethod:(NSString*)method
            WithJson:(NSDictionary*) dict
           WithGroup:(dispatch_group_t)group
     completeHandler:(request_handler_t)handler
{
   [URLRequest requestToURLDirectly:url WithMethod:method WithJson:dict WithGroup:group completeHandler:^(NSData* data) {
       // parse data
       NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       BOOL status = [[result objectForKey:@"status"] boolValue];
       id body = [result objectForKey:@"data"];
       if (body == [NSNull null]) {
           body = nil;
       }
       // complete handler
       if (handler) {
           handler(status, body);
       }
   }];
}

+(void) postToURL:(NSString*) url
         WithJson:(NSDictionary*) dict
  completeHandler:(request_handler_t) handler
{
    dispatch_group_t group = dispatch_group_create();
    [URLRequest requestToURL:url
                  WithMethod:kRequestMethodPost
                    WithJson:dict
                   WithGroup:group
             completeHandler:handler];
}

+(void) getFromURL:(NSString*) url
          WithJson:(NSDictionary*) dict
         WithGroup:(dispatch_group_t)group
   completeHandler:(request_handler_t) handler
{
    [URLRequest requestToURL:url
                  WithMethod:nil
                    WithJson:dict
                   WithGroup:group
             completeHandler:handler];
}

+(void) getFromURL:(NSString*) url
          WithJson:(NSDictionary*) dict
   completeHandler:(request_handler_t) handler
{
    dispatch_group_t group = dispatch_group_create();
    [URLRequest requestToURL:url
                  WithMethod:nil
                    WithJson:dict
                   WithGroup:group
             completeHandler:handler];
}

+(void) getFromURLDirectly:(NSString*) url
                  WithJson:(NSDictionary*) dict
                 WithGroup:(dispatch_group_t)group
           completeHandler:(result_handler_t) handler
{
    [URLRequest requestToURLDirectly:url
                          WithMethod:nil
                            WithJson:dict
                           WithGroup:group
                     completeHandler:handler];
}

+(void) postToURL:(NSString*) url
     WithDataForm:(NSDictionary*) dictData
        ImageName:(NSDictionary*) dictImgName
        ImageData:(NSDictionary*) dictImgData
  completeHandler:(request_handler_t) handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
        [request setHTTPMethod:kRequestMethodPost];
        // set form information
        NSString *boundary = @"----------------------------6a31e72a8c4c";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        // set body
        NSMutableData *body = [NSMutableData data];
        // dict data
        for (NSString* key in [dictData allKeys]) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, [dictData objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        // image data
        for (NSString* key in [dictImgName allKeys]) {
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString* imageName = [dictImgName objectForKey:key];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, imageName] dataUsingEncoding:NSUTF8StringEncoding]];
            UIImage* imageData = [dictImgData objectForKey:key];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSData alloc] initWithData:UIImageJPEGRepresentation(imageData, 1.0)]];
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
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"REQUEST failed: %@", url);
            return;
        }
        
        {
            // parse data
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            BOOL status = [[result objectForKey:@"status"] boolValue];
            id data = [result objectForKey:@"data"];
            if (data == [NSNull null]) {
                data = nil;
            }
            
            // complete handler
            if (handler) {
                handler(status, data);
            }
        }
    });
}

@end
