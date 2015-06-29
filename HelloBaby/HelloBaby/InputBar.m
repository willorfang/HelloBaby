//
//  InputBar.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/18.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "InputBar.h"

NSString* kNotificationCommentSendClicked = @"CommentSendClicked";

@implementation InputBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    float height = _sendButton.frame.size.height;
    float inputWidth = width - _sendButton.frame.size.width;
    self.bounds = CGRectMake(0, 0, width, height);
    //
    _inputView.frame = CGRectMake(0, 0,
                                  inputWidth, _sendButton.frame.size.height);
    _inputView.delegate = self;
    //
    _sendButton.frame = CGRectMake(inputWidth, 0,
                                   _sendButton.frame.size.width, _sendButton.frame.size.height);
}

+ (instancetype)view
{
    NSString *className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
}

- (IBAction)sendClicked:(id)sender {
    NSDictionary *info = [NSDictionary dictionaryWithObjects:@[_inputView.text]
                                                     forKeys:@[@"content"]];
    NSNotification *notification = [NSNotification notificationWithName:kNotificationCommentSendClicked
                                                                 object:self
                                                               userInfo:info];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma -- TextViewDelegate

// update size automically
- (void)textViewDidChange:(UITextView *)textView
{
    // textview
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    textView.frame = frame;
    
    // parent
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, textView.contentSize.height);
}

@end
