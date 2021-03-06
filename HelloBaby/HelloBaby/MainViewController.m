//
//  MainViewController.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "MainViewController.h"
#import "PostView.h"
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
    
    _scrollView.delegate = self;
    
    // hidden field
    _hiddenField = [[UITextField alloc] init];
    [self.view addSubview:_hiddenField];
    // add input view for comment
    _inputBar = [InputBar view];
    _hiddenField.inputAccessoryView = _inputBar;
    
    [self initializeView];
    
    // notifications
    _commentToPost = [[CommentDataForPost alloc] init];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(commentButtonClicked:) name:kNotificationCommentButtonClicked object:nil];
    [nc addObserver:self
           selector:@selector(commentSendClicked:) name:kNotificationCommentSendClicked object:nil];
    [nc addObserver:self
           selector:@selector(goodButtonClicked:) name:kNotificationGoodButtonClicked object:nil];
}

-(void)commentButtonClicked:(NSNotification*)notification
{
    // show keyboard
    _hiddenField.userInteractionEnabled = YES;
    [_hiddenField becomeFirstResponder];
    // data
    _commentToPost.record_id = [[[notification userInfo] objectForKey:@"record_id"] integerValue];
    _commentToPost.poster_id = [[[notification userInfo] objectForKey:@"poster_id"] integerValue];
    _commentToPost.order = [[[notification userInfo] objectForKey:@"order"] integerValue];
}

-(void)commentSendClicked:(NSNotification*)notification
{
    // hide keyboard
    _hiddenField.userInteractionEnabled = NO;
    [_hiddenField resignFirstResponder];
    [self.view endEditing:YES];
    //data
    _commentToPost.content = [[notification userInfo] objectForKey:@"content"];
    // send to server
    PostDataRequest* req = [[PostDataRequest alloc] init];
    [req addCommentToPost:_commentToPost.record_id
                   byUser:_commentToPost.poster_id
              withMessage:_commentToPost.content completeHandler:^(BOOL status, id result){
                  if (status) {
                      NSLog(@"Add Comment succeed.");
                      CommentDataForShow* commentData = [[CommentDataForShow alloc] init];
                      commentData.content = _commentToPost.content;
                      commentData.username = [[UserData sharedUser] username];
                      PostData* postData = [_postDataArray objectAtIndex:_commentToPost.order];
                      [postData.commentArray addObject:commentData];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self reloadPostViews];
                      });
                  } else {
                      NSLog(@"Add Comment Failed.");
                  }
    }];
    
}

-(void)goodButtonClicked:(NSNotification*)notification
{
    NSDictionary* dict = [notification userInfo];
    NSInteger poster_id = [[dict objectForKey:@"poster_id"] integerValue];
    NSInteger record_id = [[dict objectForKey:@"record_id"] integerValue];
    NSInteger order = [[dict objectForKey:@"order"] integerValue];
    //
    PostDataRequest* req = [[PostDataRequest alloc] init];
    [req addGoodToPost:record_id byUser:poster_id completeHandler:^(BOOL succeed, id results) {
        if (succeed) {
            NSLog(@"Add good succeed.");
            PostData* postData = [_postDataArray objectAtIndex:order];
            ++postData.goodNum;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadPostViews];
            });
        } else {
            NSLog(@"Add good fail.");
        }
    }];
    
}

-(void)initializeView
{
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
    _nextPageNum = 0;
    [_request requestPostsAboutBaby:user.baby.id pageNum:_nextPageNum updateHandler:^(NSMutableArray *data) {
        _postDataArray = data;
        dispatch_async(dispatch_get_main_queue(), ^{
            // create post views
            ++_nextPageNum;
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

#pragma -- UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat scrollHeight = scrollView.frame.size.height;
        CGFloat bottomInset = scrollView.contentInset.bottom;
        CGFloat bottomScrollY = offsetY + scrollHeight - bottomInset;
        CGFloat fuzzFactor = 20;
        CGFloat boundary = scrollView.contentSize.height - fuzzFactor;
        if (bottomScrollY >= boundary) {
            NSLog(@"Scrolled to the bottom");
            //
            [_activityIndicator startAnimating];
            
            // request more contents HERE
            UserData* user = [UserData sharedUser];
            PostDataRequest* request = [[PostDataRequest alloc] init];
            // TODO: change pageNum to _nextPageNum
            [request requestPostsAboutBaby:user.baby.id pageNum:0 updateHandler:^(NSMutableArray *data) {
                [_postDataArray addObjectsFromArray:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // create post views
                    ++_nextPageNum;
                    // TODO: no sleep
                    [NSThread sleepForTimeInterval:2];
                    [_activityIndicator stopAnimating];
                    [self reloadPostViews];
                });
            }];
        }
    }
}


#pragma -- create post views

-(void) reloadPostViews
{
    // clear
    CGFloat margin = [PostView margin];
    CGFloat originY = _startY;
    [_postViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _postViewArray = [[NSMutableArray alloc] init];
    
    int index = 0;
    for (id item in _postDataArray) {
        PostData* postData = (PostData*)item;
        PostView* cell = [[PostView view] fillWithData:postData];
        cell.order = index++;
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
