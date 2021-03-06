//
//  PostView.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "PostView.h"
#import "PostData.h"
#import "UserData.h"

NSString* kNotificationCommentButtonClicked = @"CommentButtonClicked";
NSString* kNotificationGoodButtonClicked = @"GoodButtonClicked";

@implementation PostView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _commentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - [PostView margin]*2;
    self.bounds = CGRectMake(0, 0, width, 0);
    //
    [_commentTableView setDataSource:self];
    [_commentTableView setDelegate:self];
}

+ (CGFloat)margin
{
    return 8;
}

+ (instancetype)view
{
    NSString *className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
}

- (id) fillWithData:(PostData *)data
{
    _data = data;
    [self reload];
    return self;
}

- (void) reload
{
    static const CGFloat spacing = 5;
    CGFloat originY = 0;
    // content
    if ([_data.postMsg length] > 0) {
        _postLabel.text = _data.postMsg;
        [_postLabel sizeToFit];
        [_postLabel setFrame:CGRectMake(_postLabel.frame.origin.x,
                                        originY,
                                        _postLabel.frame.size.width,
                                        _postLabel.frame.size.height)];
    } else {
        [_postLabel setFrame:CGRectMake(_postLabel.frame.origin.x,
                                        originY,
                                        0,
                                        0)];
    }
    // image
    if (_data.postImage) {
        _postImage.contentMode = UIViewContentModeScaleAspectFit;
        [_postImage setImage:_data.postImage];
        originY +=  _postLabel.frame.size.height + spacing;
        [_postImage setFrame:CGRectMake(_postImage.frame.origin.x,
                                        originY,
                                        _postImage.frame.size.width,
                                        _postImage.frame.size.height)];
    } else {
        originY += _postLabel.frame.size.height;
        [_postImage setFrame:CGRectMake(_postImage.frame.origin.x,
                                        originY,
                                        0,
                                        0)];
    }
    // status
    _postStatus.text = [_data getStatusString];
    originY += _postImage.frame.size.height + spacing;
    [_postStatus setFrame:CGRectMake(_postStatus.frame.origin.x,
                                    originY,
                                    _postStatus.frame.size.width,
                                    _postStatus.frame.size.height)];
    [_goodButton setFrame:CGRectMake(_goodButton.frame.origin.x,
                                     originY,
                                     _goodButton.frame.size.width,
                                     _goodButton.frame.size.height)];
    [_commentButton setFrame:CGRectMake(_commentButton.frame.origin.x,
                                     originY,
                                     _commentButton.frame.size.width,
                                     _commentButton.frame.size.height)];
    // good
    [_goodButton setTitle:[NSString stringWithFormat:@"%ld", (long)_data.goodNum] forState:UIControlStateNormal];
    
    // comment
    _commentArray = _data.commentArray;
    originY += _goodButton.frame.size.height + spacing;
    [_commentTableView reloadData];
    [_commentTableView setFrame: CGRectMake(_commentTableView.frame.origin.x,
                                           originY,
                                           _commentTableView.contentSize.width,
                                           _commentTableView.contentSize.height)];
    //
    originY += _commentTableView.frame.size.height + spacing;
    [self setBounds:CGRectMake(0, 0, self.bounds.size.width, originY)];
}

- (IBAction)goodClicked:(id)sender {
    NSNumber* poster_id = [NSNumber numberWithInteger:[[UserData sharedUser] user_id]];
    NSNumber* record_id = [NSNumber numberWithInteger:_data.postID];
    NSNumber* order = [NSNumber numberWithInteger:self.order];
    NSDictionary *info = [NSDictionary dictionaryWithObjects:@[poster_id, record_id, order]
                                                     forKeys:@[@"poster_id", @"record_id", @"order"]];
    NSNotification *notification = [NSNotification notificationWithName:kNotificationGoodButtonClicked
                                                                 object:self
                                                               userInfo:info];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)commentClicked:(id)sender {
    NSNumber* poster_id = [NSNumber numberWithInteger:[[UserData sharedUser] user_id]];
    NSNumber* record_id = [NSNumber numberWithInteger:_data.postID];
    NSNumber* order = [NSNumber numberWithInteger:self.order];
    NSDictionary *info = [NSDictionary dictionaryWithObjects:@[poster_id, record_id, order, @""]
                                                     forKeys:@[@"poster_id", @"record_id", @"order", @"content"]];
    NSNotification *notification = [NSNotification notificationWithName:kNotificationCommentButtonClicked
                                      object:self
                                    userInfo:info];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma -- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count];
}

- (NSString*) getCommentStringForIndex:(NSInteger)index
{
    CommentDataForShow* commentData = (CommentDataForShow*) [_commentArray objectAtIndex:index];
    NSString* commentStr = [NSString stringWithFormat:@"%@:%@", commentData.username, commentData.content];
    return commentStr;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get an cell
    static NSString* identifier = @"post-comment-cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // initilize the cell
    cell.textLabel.text = [self getCommentStringForIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // multiline
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const CGFloat spacing = 5;
    NSString *cellText = [self getCommentStringForIndex:indexPath.row];
    UIFont *cellFont = [UIFont systemFontOfSize:12.0];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:cellText
                                                                         attributes:@{
                                                                                      NSFontAttributeName: cellFont
                                                                                      }];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size.height + spacing;
}

#pragma -- TableView Delegate

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
}

@end
