//
//  URLRequest.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/07/01.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^request_handler_t)(BOOL succeed, id results);
typedef void (^result_handler_t)(NSData* results);

@interface URLRequest : NSObject

+(void) postToURL:(NSString*) url
         WithJson:(NSDictionary*) dict
  completeHandler:(request_handler_t) handler;

+(void) getFromURL:(NSString*) url
          WithJson:(NSDictionary*) dict
   completeHandler:(request_handler_t) handler;

+(void) getFromURL:(NSString*) url
          WithJson:(NSDictionary*) dict
         WithGroup:(dispatch_group_t)group
   completeHandler:(request_handler_t) handler;

+(void) getFromURLDirectly:(NSString*) url
                  WithJson:(NSDictionary*) dict
                 WithGroup:(dispatch_group_t)group
           completeHandler:(result_handler_t) handler;

+(void) postToURL:(NSString*) url
     WithDataForm:(NSDictionary*) dictData
     ImageName:(NSDictionary*) dictImgName
     ImageData:(NSDictionary*) dictImgData
  completeHandler:(request_handler_t) handler;

@end
