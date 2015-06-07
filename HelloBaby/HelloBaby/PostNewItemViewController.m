//
//  PostNewItemViewController.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/05/11.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "PostNewItemViewController.h"
#import "MainViewController.h"
#import "PostData.h"

@interface PostNewItemViewController ()

+(NSString*)getCurrentTime;

@end

@implementation PostNewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+(NSString*)getCurrentTime
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd 灵松之雪";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:now];
}

- (IBAction)sendButtonClicked:(id)sender
{
    if ([_postText.text length] > 0 || _uploadedImage) {
        // data
        PostData* data = [[PostData alloc] init];
        data.postMsg = _postText.text;
        data.postImage = _uploadedImage;
        data.postStatus = [PostNewItemViewController getCurrentTime];
        // request to server
        PostDataRequest* request = [[PostDataRequest alloc] init];
        [request postAboutBaby:1 byUser:1 withMessage:_postText.text AndImage:_uploadedImage completeHandler:^{
            // udpate UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [_parent updateWithAddPostData:data];
            });
        }];
    }
    //
    [_parent dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postImageButtonClicked:(id)sender
{
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _uploadedImage = info[UIImagePickerControllerEditedImage];
    [_postImageButton setImage:_uploadedImage forState:UIControlStateDisabled];
    [_postImageButton setEnabled:NO];
}

@end
