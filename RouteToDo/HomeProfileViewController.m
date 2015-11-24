//
//  HomeViewController.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "HomeProfileViewController.h"
#import "RouteListViewController.h"
#import "ProfileViewController.h"

@interface HomeProfileViewController () <UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) RouteListViewController *routeListViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) UIViewController *currentController;

@end

@implementation HomeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBar.selectedItem = self.tabBar.items[0];
    [self tabBar:self.tabBar didSelectItem:self.tabBar.items[0]];

    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    if (self.routeListViewController != self.currentController) {
        self.routeListViewController = nil;
    }

    if (self.profileViewController != self.currentController) {
        self.profileViewController = nil;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch ([tabBar.items indexOfObject:item]) {
        case 0:
            [self showRouteListViewController];
            break;

        case 1:
            [self showProfileViewController];
            break;

        default:
            break;
    }
}

/* called when user shows or dismisses customize sheet. you can use the 'willEnd' to set up what appears underneath.
 changed is YES if there was some change to which items are visible or which order they appear. If selectedItem is no longer visible,
 it will be set to nil.
 */

//- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray<UITabBarItem *> *)items __TVOS_PROHIBITED;                     // called before customize sheet is shown. items is current item list
//- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray<UITabBarItem *> *)items __TVOS_PROHIBITED;                      // called after customize sheet is shown. items is current item list
//- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray<UITabBarItem *> *)items changed:(BOOL)changed __TVOS_PROHIBITED; // called before customize sheet is hidden. items is new item list
//- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray<UITabBarItem *> *)items changed:(BOOL)changed __TVOS_PROHIBITED;  // called after customize sheet is hidden. items is new item list


- (void) showRouteListViewController {
    if (self.routeListViewController == nil) {
        self.routeListViewController = [[RouteListViewController alloc] init];
    }

    [self presentController:self.routeListViewController];
}

- (void) showProfileViewController {
    if (self.profileViewController == nil) {
        self.profileViewController = [[ProfileViewController alloc] init];
    }

    [self presentController:self.profileViewController];
}

- (void) presentController:(UIViewController *)controller {
    if (self.currentController == controller) {
        return;
    }

    if (self.currentController) {
        [self.currentController willMoveToParentViewController:nil];
        [self.currentController.view removeFromSuperview];
        [self.currentController didMoveToParentViewController:nil];
    }

    self.currentController = controller;

    [self addChildViewController:self.currentController];
    self.currentController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.currentController.view];
    [self.currentController didMoveToParentViewController:self];
}

@end
