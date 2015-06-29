//
//  InputBar.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/18.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString* kNotificationCommentSendClicked;

@interface InputBar : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

+ (instancetype)view;
- (IBAction)sendClicked:(id)sender;

@end
