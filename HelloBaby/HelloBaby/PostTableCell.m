//
//  PostTableCell.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "PostTableCell.h"

@implementation PostTableCell

static const CGFloat spacing = 5;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _commentArray = [[NSArray alloc] init];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [_commentTableView setDataSource:self];
    [_commentTableView setDelegate:self];
}

+ (instancetype)view
{
    NSString *className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
}

- (id) fillWithData:(PostData *)data
{
    CGFloat originY = spacing;
    //
    _postLabel.text = data.postMsg;
    [_postLabel sizeToFit];
    [_postLabel setFrame:CGRectMake(_postLabel.frame.origin.x,
                                    originY,
                                    _postLabel.frame.size.width,
                                    _postLabel.frame.size.height)];
    //
    _postImage.contentMode = UIViewContentModeScaleAspectFit;
    [_postImage setImage:[UIImage imageNamed:data.postImageName]];
    originY = _postLabel.frame.origin.y + _postLabel.frame.size.height + spacing;
    [_postImage setFrame:CGRectMake(_postImage.frame.origin.x,
                                    originY,
                                    _postImage.frame.size.width,
                                    _postImage.frame.size.height)];
    //
    _postStatus.text = data.postStatus;
    originY = _postImage.frame.origin.y + _postImage.frame.size.height + spacing;
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
    //
    _commentArray = data.commentArray;
    originY = _likeButton.frame.origin.y + _likeButton.frame.size.height + spacing;
    [_commentTableView reloadData];
    [_commentTableView setFrame: CGRectMake(_commentTableView.frame.origin.x,
                                           originY,
                                           _commentTableView.contentSize.width,
                                           _commentTableView.contentSize.height)];
    //
    originY = _commentTableView.frame.origin.y + _commentTableView.frame.size.height + spacing;
    [self setBounds:CGRectMake(0, 0, self.bounds.size.width, originY)];
    
    return self;
}

#pragma -- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count];
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
    cell.textLabel.text = (NSString*) [_commentArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // multiline
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText =[_commentArray objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont systemFontOfSize:13.0];
    
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
