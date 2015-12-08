//
//  LoginViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "LoginViewController.h"
#import "RouteCoverViewController.h"
#import "HomeProfileViewController.h"
#import "RouteListViewController.h"
#import "ProfileViewController.h"
#import "RouteCoverViewController.h"
#import "CustomTabControllerItem.h"
#import "BackendRepository.h"

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
    if (animated) {
        self.logoTopConstraint.constant = 40;
        self.emailTextField.alpha = 1;
        self.loginButton.alpha = 1;
    } else {
        self.logoTopConstraint.constant = 179;
        self.emailTextField.alpha = 0;
        self.loginButton.alpha = 0;
    }

    [self.view layoutIfNeeded];
}

- (void) viewDidAppear:(BOOL)animated {
    if (!animated) {
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
    // Dispose of any resources that can be recreated.

}

- (IBAction)onLoginButtonTap:(UIButton *)sender {
    id<BackendRepository> repo = [BackendRepository sharedInstance];

    [repo loginUserWithEmail:self.emailTextField.text completion:^(User *user, NSError *error) {
        if (user) {
            [User setCurrentUser:user];
        } else {
            NSLog(@"show login error");
        }
    }];
}

@end
