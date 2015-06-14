//
//  PostTableCell.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "PostTableCell.h"

@implementation PostTableCell

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
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - [PostTableCell margin]*2;
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
    static const CGFloat spacing = 5;
    CGFloat originY = 0;
    // content
    if ([data.postMsg length] > 0) {
        _postLabel.text = data.postMsg;
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
    if (data.postImage) {
        _postImage.contentMode = UIViewContentModeScaleAspectFit;
        [_postImage setImage:data.postImage];
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
    _postStatus.text = [data getStatusString];
    originY += _postImage.frame.size.height + spacing;
    [_postStatus setFrame:CGRectMake(_postStatus.frame.origin.x,
                                    originY,
                                    _postStatus.frame.size.width,
                                    _postStatus.frame.size.height)];
    [_likeButton setFrame:CGRectMake(_likeButton.frame.origin.x,
                                     originY,
                                     _likeButton.frame.size.width,
                                     _likeButton.frame.size.height)];
    [_commentButton setFrame:CGRectMake(_commentButton.frame.origin.x,
                                     originY,
                                     _commentButton.frame.size.width,
                                     _commentButton.frame.size.height)];
    // good
    [_likeButton setTitle:[NSString stringWithFormat:@"%ld", (long)data.likeNum] forState:UIControlStateNormal];
    
    // comment
    _commentArray = data.commentArray;
    originY += _likeButton.frame.size.height + spacing;
    [_commentTableView reloadData];
    [_commentTableView setFrame: CGRectMake(_commentTableView.frame.origin.x,
                                           originY,
                                           _commentTableView.contentSize.width,
                                           _commentTableView.contentSize.height)];
    //
    originY += _commentTableView.frame.size.height + spacing;
    [self setBounds:CGRectMake(0, 0, self.bounds.size.width, originY)];
    
    return self;
}

#pragma -- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count];
}

- (NSString*) getCommentStringForIndex:(NSInteger)index
{
    CommentData* commentData = (CommentData*) [_commentArray objectAtIndex:index];
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
