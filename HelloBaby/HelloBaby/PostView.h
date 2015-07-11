//
//  PostView.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostData.h"

FOUNDATION_EXPORT NSString* kNotificationCommentButtonClicked;

@interface PostView : UIView<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* _commentArray;
    PostData* _data;
}

@property (strong, nonatomic) IBOutlet UITextView *postLabel;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) IBOutlet UITextField *postStatus;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic) NSInteger order;

+ (instancetype)view;
+ (CGFloat)margin;
- (id) fillWithData:(PostData*)data;
- (void) reload;
- (NSString*) getCommentStringForIndex:(NSInteger)index;
- (IBAction)goodClicked:(id)sender;
- (IBAction)commentClicked:(id)sender;

@end
