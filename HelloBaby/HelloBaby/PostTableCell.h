//
//  PostTableCell.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostData.h"

@interface PostTableCell : UIView<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* _commentArray;
}

@property (strong, nonatomic) IBOutlet UITextView *postLabel;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) IBOutlet UITextField *postStatus;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;

+ (instancetype)view;
+ (CGFloat)margin;
- (id) fillWithData:(PostData*)data;
- (NSString*) getCommentStringForIndex:(NSInteger)index;

@end
