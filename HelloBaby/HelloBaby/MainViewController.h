//
//  MainViewController.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostData.h"

@interface MainViewController : UIViewController {
    PostDataRequest* _request;
    NSMutableArray* _postDataArray;
    CGFloat _startY;
    NSMutableArray* _postViewArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviItem;


- (IBAction)unwindToMainViewController:(UIStoryboardSegue *)segue;
- (void)updateWithAddPostData:(PostData*)data;
@end

