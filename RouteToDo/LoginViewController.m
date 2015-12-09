//
//  LoginViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "LoginViewController.h"
#import "BackendRepository.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailTextFieldTopConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.animated) {
        self.logoTopConstraint.constant = 179;
        self.emailTextField.alpha = 0;
        self.loginButton.alpha = 0;
    } else {
        self.logoTopConstraint.constant = 40;
        self.emailTextField.alpha = 1;
        self.loginButton.alpha = 1;
    }

    [self.view layoutIfNeeded];
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.logoTopConstraint.constant = 40;
            self.emailTextField.alpha = 1;
            self.loginButton.alpha = 1;

            [self.view layoutIfNeeded];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onLoginButtonTap:(UIButton *)sender {
    id<BackendRepository> repo = [BackendRepository sharedInstance];

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD show];
    [repo loginUserWithEmail:self.emailTextField.text completion:^(User *user, NSError *error) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (user) {
            [SVProgressHUD dismiss];
            [User setCurrentUser:user];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Incorrect login"];
        }
    }];
}

@end
