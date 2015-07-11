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
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)login:(id)sender;
- (IBAction)signUp:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _usernameTextField.delegate = self;
    _passwordField.delegate = self;
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
    
    [_activityIndicator startAnimating];
    [UserData loginWithName:username password:password completeHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            [self performSegueWithIdentifier:@"segueLogined" sender:self];
        });
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, set focus.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, remove keyboard.
        [textField resignFirstResponder];
        // login
        [_loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return NO; // Do not insert line-breaks.
}

- (IBAction)signUp:(id)sender {
}
@end
