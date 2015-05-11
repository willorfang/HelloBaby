//
//  PostNewItemViewController.h
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/11.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostNewItemViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImage* _uploadedImage;
}

@property (weak, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet UIButton *postImageButton;
@property (weak, nonatomic) id parent;

- (IBAction)sendButtonClicked:(id)sender;
- (IBAction)postImageButtonClicked:(id)sender;
@end
