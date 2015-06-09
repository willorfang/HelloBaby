//
//  MainViewController.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "MainViewController.h"
#import "PostTableCell.h"
#import "PostNewItemViewController.h"
#import "UserData.h"

@interface MainViewController ()

-(void)reloadPostViews;

@end

@implementation MainViewController

static NSString* identifier = @"post-cell";
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    // init user info
    UserData* user = [UserData sharedUser];
    
    _statusLabel.text = user.baby.status;
    _naviItem.title = [user getIdentityName];
    if (user.baby.avatar) {
        _avatarImageView.image = [UIImage imageWithData:user.baby.avatar];
    }
    if (user.baby.background) {
        _backgroundImageView.image = [UIImage imageWithData:user.baby.background];
    }
    
    // prepare the post data here
    _request = [[PostDataRequest alloc] init];
    [_request requestPostsAboutBaby:user.baby.id pageNum:0 updateHandler:^(NSMutableArray *data) {
        _postDataArray = data;
        dispatch_async(dispatch_get_main_queue(), ^{
            // create post views
            _startY = _backgroundImageView.frame.origin.y + _backgroundImageView.frame.size.height;
            [self reloadPostViews];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -- create post views

-(void) reloadPostViews
{
    // clear
    CGFloat margin = [PostTableCell margin];
    CGFloat originY = _startY;
    [_postViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _postViewArray = [[NSMutableArray alloc] init];
    
    for (id item in _postDataArray) {
        PostData* postData = (PostData*)item;
        PostTableCell* cell = [[PostTableCell view] fillWithData:postData];
        //
        cell.frame = CGRectMake(margin, originY, cell.frame.size.width, cell.frame.size.height);
        [_scrollView addSubview:cell];
        //
        originY += cell.bounds.size.height + margin;
        [_postViewArray addObject:cell];
    }
    
    // ATTENTION: need to set content size
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width,
                                           originY - _startY + _backgroundImageView.frame.size.height)];
}

- (IBAction)unwindToMainViewController:(UIStoryboardSegue *)segue
{
    
}

- (void)updateWithAddPostData:(PostData*)data
{
    [_postDataArray insertObject:data atIndex:0];
    [self reloadPostViews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PostNewItemViewController* dest = (PostNewItemViewController*)segue.destinationViewController;
    dest.parent = self;
}

@end
