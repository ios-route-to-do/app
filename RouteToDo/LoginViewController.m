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

#import "mocks.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onRouteDetailsClick:(id)sender {
    RouteCoverViewController *vc = [[RouteCoverViewController alloc] init];
    vc.route = mockRoute1();
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)onRouteListClick:(id)sender {
    RouteListViewController *homeController = [[RouteListViewController alloc] init];
    UIImage *homeImage = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomTabControllerItem *homeItem = [CustomTabControllerItem itemWithTitle:@"Home" image:homeImage andController:homeController];

    ProfileViewController *profileController = [[ProfileViewController alloc] init];
    UIImage *profileImage = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomTabControllerItem *profileItem = [CustomTabControllerItem itemWithTitle:@"Profile" image:profileImage andController:profileController];
    
    HomeProfileViewController *vc = [[HomeProfileViewController alloc] initWithItems:@[homeItem, profileItem]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    [self presentViewController:nav animated:YES completion:nil];
//
//    NSLog(@"on Route List click");
//    RouteListViewController *routeListVC = [[RouteListViewController alloc] init];
//    UINavigationController* routeListNVC = [[UINavigationController alloc] initWithRootViewController:routeListVC];
//    routeListNVC.tabBarItem.title = @"Route List";
//
//    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
//    UINavigationController *profileNVC = [[UINavigationController alloc] initWithRootViewController:profileVC];
//    profileNVC.tabBarItem.title = @"Profile View";
//    
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    tabBarController.viewControllers = @[routeListNVC, profileNVC];
//
//    [self presentViewController:tabBarController animated:YES completion:nil];
    
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
