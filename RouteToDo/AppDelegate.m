//
//  AppDelegate.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeProfileViewController.h"
#import "CategoriesViewController.h"
#import "LoginViewController.h"
#import "BackendRepository.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserMissingNotification:) name:UserMissingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserPresentNotification:) name:UserPresentNotification object:nil];

    //Check for current user
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [User currentUser];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onUserMissingNotification:(NSNotification *)notification {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.animated = (notification.userInfo[@"forget"] == nil);
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

- (void)onUserPresentNotification:(NSNotification *)notification {
    CategoriesViewController *vc = [[CategoriesViewController alloc] init];

    if ([self.window.rootViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginController = (LoginViewController *)self.window.rootViewController;

        [UIView animateWithDuration:0.2 animations:^{
            loginController.logoTopConstraint.constant = 24;
            loginController.logoHeightConstraint.constant = 28;
            loginController.logoWidthConstraint.constant = 59;
            [loginController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self blendRootViewController:vc];
            [self.window makeKeyAndVisible];
        }];
    } else {
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
    }
}

- (void)changeRootViewController:(UIViewController*)viewController {

    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }

    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];

    [viewController.view addSubview:snapShot];

    self.window.rootViewController = viewController;

    [UIView animateWithDuration:0.2 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

- (void)blendRootViewController:(UIViewController*)viewController {
    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }

    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];

    [viewController.view addSubview:snapShot];

    self.window.rootViewController = viewController;

    [UIView animateWithDuration:0.1 animations:^{
        snapShot.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

@end
