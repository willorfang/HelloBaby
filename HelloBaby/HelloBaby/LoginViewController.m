//
//  LoginViewController.m
//  HelloBaby
//
//  Created by Wei Fang on 2015/06/13.
//  Copyright (c) 2015年 Wei Fang. All rights reserved.
//

#import "LoginViewController.h"
#import "UserData.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)login:(id)sender;
- (IBAction)signUp:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_usernameTextField becomeFirstResponder];
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

- (IBAction)login:(id)sender {
    NSString* username = _usernameTextField.text;
    NSString* password = _passwordField.text;
    [UserData loginWithName:username password:password];
}

- (IBAction)signUp:(id)sender {
}
@end
