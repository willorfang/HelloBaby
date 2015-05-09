//
//  PostTableCell.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/09.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "PostTableCell.h"

@implementation PostTableCell

- (void)awakeFromNib {
    // Initialization code
    _commentArray = [[NSArray alloc] init];
    //
    [_commentTableView setDataSource:self];
    [_commentTableView setDelegate:self];
}


#pragma -- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_commentArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // get an cell
    static NSString* identifier = @"post-comment-cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    // initilize the cell
    cell.textLabel.text = (NSString*) [_commentArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma -- TableView Delegate

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
     
}

@end
