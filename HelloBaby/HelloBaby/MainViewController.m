//
//  MainViewController.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "MainViewController.h"
#import "PostTableCell.h"
#import "PostData.h"

@interface MainViewController ()

-(void)reloadPostViews;

@end

@implementation MainViewController

static NSString* identifier = @"post-cell";
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // prepare the post data here
    _postDataArray = [[NSMutableArray alloc] init];
    //
    PostData* data1 = [[PostData alloc] init];
    data1.postMsg = @"看我的舌头真好看!";
    data1.postImageName = @"baby1.jpg";
    data1.postStatus = @"2015/03/12 灵松之雪";
    data1.commentArray = [NSArray arrayWithObjects:@"真可爱!", @"赞!", @"卡哇伊!", nil];
    PostData* data2 = [[PostData alloc] init];
    data2.postMsg = @"妈妈打屁屁了!";
    data2.postImageName = @"baby2.jpg";
    data2.postStatus = @"2015/05/10 灵松之雪";
    data2.commentArray = [NSArray arrayWithObjects:@"狠心的妈妈!", @"好像亲自去哄...", @"唉，叫你不听话吧...", nil];
    [_postDataArray addObject:data1];
    [_postDataArray addObject:data2];
    
    // create post views
    _startY = _backgroundImageView.frame.origin.y + _backgroundImageView.frame.size.height;
    [self reloadPostViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -- create post views

-(void) reloadPostViews {
    // clear
    CGFloat originY = _startY;
    [_postViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _postViewArray = [[NSMutableArray alloc] init];
    
    for (id item in _postDataArray) {
        PostData* postData = (PostData*)item;
        PostTableCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"PostTableCell" owner:self options:nil] objectAtIndex:0];
        //
        cell.postLabel.text = postData.postMsg;
        [cell.postLabel sizeToFit];
        //
        cell.postImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell.postImage setImage:[UIImage imageNamed:postData.postImageName]];
        //
        cell.postStatus.text = postData.postStatus;
        cell.commentArray = postData.commentArray;
        //
        cell.frame = CGRectMake(0, originY, cell.frame.size.width, cell.frame.size.height);
        [_scrollView addSubview:cell];
        //
        originY += cell.bounds.size.height;
        [_postViewArray addObject:cell];
    }
    
    // ATTENTION: need to set content size
    [_scrollView setContentSize:CGSizeMake(320, originY-_startY+_backgroundImageView.frame.size.height)];
}

@end
