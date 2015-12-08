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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
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
