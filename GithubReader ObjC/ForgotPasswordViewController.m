//
//  ForgotPasswordViewController.m
//  GithubReader ObjC
//
//  Created by Dorokhin on 29.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "NSString+emailValidation.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendUserEmailButton;
@property (weak, nonatomic) IBOutlet UIView *userSignInDataView;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userSignInDataView.layer.borderColor = Rgb2UIColor(216, 222, 226).CGColor;
    self.sendUserEmailButton.layer.borderColor = Rgb2UIColor(44, 165, 74).CGColor;
    self.userEmailTextField.backgroundColor = Rgb2UIColor(250, 255, 189);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sendUserEmailButtonClicked:(id)sender {
    if([self validateText]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark -
#pragma mark  Validation
- (BOOL)validateText {
    NSString *errorMsg;
    
    if(![self.userEmailTextField.text isValidEmail]) {
        errorMsg = @"User email is not valid";
        
        [APPDELEGATE showMessage:errorMsg withTitle:@"WRONG!"];
        
        return NO;
    }else{
        return YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
