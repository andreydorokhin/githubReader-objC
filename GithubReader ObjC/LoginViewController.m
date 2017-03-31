//
//  ViewController.m
//  GithubReader ObjC
//
//  Created by Dorokhin on 21.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"
#import "UAGithubEngine.h"
#import "AppDelegate.h"
#import "ServerManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+emailValidation.h"


@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *userSignInDataView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (assign, nonatomic) CGFloat currentKeyboardY;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userSignInDataView.layer.borderColor = Rgb2UIColor(216, 222, 226).CGColor;
    self.signInButton.layer.borderColor = Rgb2UIColor(44, 165, 74).CGColor;
    self.userEmailTextField.backgroundColor = Rgb2UIColor(250, 255, 189);
    self.userPasswordTextField.backgroundColor = Rgb2UIColor(250, 255, 189);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn) name:@"LoginSuccess" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signInButtonClicked:(id)sender {
    [self login];
}

- (void)login {
    if([self validateText]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/login/oauth/authorize?scope=nil&client_id=%@", CLIENT_ID]];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
}

- (void)loggedIn {
    [self getAccessToken];
}

- (void)goToRepositories {
    [self performSegueWithIdentifier:@"RepositoriesSegue" sender:nil];
}

- (void)getAccessToken {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID,              @"client_id",
                                                                    CLIENT_SECRET,          @"client_secret",
                                                                    APPDELEGATE.authCode,   @"code", nil];
    
    [[ServerManager sharedServerManagerWithURL:@"https://github.com/login/oauth/access_token"]
                         postRequestWithSubURL:@""
                                 andParameters:dict
                                     onSuccess:^(NSDictionary *responseObject) {
                                         
                                         APPDELEGATE.authAccessToken = [responseObject objectForKey:@"access_token"];
                                         [self getAuthenticatedUser];
                                     } onFailure:^(NSDictionary *responseObject) {
                                         
                                     }];
}

- (void)getAuthenticatedUser {
    //  https://api.github.com/users/whatever?client_id=xxxx&client_secret=yyyy
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/user?access_token=%@", APPDELEGATE.authAccessToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    if(error) {
                                                        NSLog(@"Error: %@", error);
                                                    }else {
                                                        if(responseObject && ((NSHTTPURLResponse*)response).statusCode == 200) {
                                                            APPDELEGATE.engine = [[UAGithubEngine alloc] initWithUsername:[responseObject objectForKey:@"login"] password:self.userPasswordTextField.text withReachability:YES];
                                                            
                                                            APPDELEGATE.authUsername = [responseObject objectForKey:@"login"];
                                                            
                                                            [self goToRepositories];
                                                        }
                                                    }
                                                }];
    
    [dataTask resume];
}

#pragma mark - 
#pragma mark  Validation
- (BOOL)validateText {
    NSString *errorMsg;

    if(![self.userEmailTextField.text isValidEmail]) {
        errorMsg = @"User email is not valid";
        
        [APPDELEGATE showMessage:errorMsg withTitle:@"WRONG!"];
        
        return NO;
    }else if (self.userPasswordTextField.text.length == 0){
        errorMsg = @"Please provide password";
        
        [APPDELEGATE showMessage:errorMsg withTitle:@"WRONG!"];
        
        return NO;
    }else{
        return YES;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.userEmailTextField) {
        [self.userPasswordTextField becomeFirstResponder];
    }else if (textField == self.userPasswordTextField) {
        [self.userPasswordTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField:textField up:NO];
}

- (void)animateTextField:(UITextField*)textField up:(BOOL)up {
    const int movementDistance = -kOFFSET_FOR_KEYBOARD;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.userSignInDataView.frame = CGRectOffset(self.userSignInDataView.frame, 0, movement);
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Unwind Segues To LoginViewController

- (IBAction)unwindToMainMenu:(UIStoryboardSegue *)unwindSegue {

}

@end
