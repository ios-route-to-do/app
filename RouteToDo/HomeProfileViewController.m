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
#import "RouteCoverEditViewController.h"
#import "CategoriesViewController.h"

#import "AppDelegate.h"
#import "CustomTabControllerItem.h"
#import "YALFoldingTabBar.h"
#import "YALTabBarItem.h"
#import "YALAnimatingTabBarConstants.h"

#include "Utils.h"

@interface HomeProfileViewController () <YALTabBarViewDataSource, YALTabBarViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (nonatomic) YALFoldingTabBar *tabBar;

@property (nonatomic) NSArray<CustomTabControllerItem *> *controllerItems;
@property (nonatomic) UIViewController *currentController;

@property (nonatomic) NSArray *leftTabBarItems;
@property (nonatomic) NSArray *rightTabBarItems;
@property (nonatomic) NSArray *tabBarItems;

@end

@implementation HomeProfileViewController

- (instancetype) initDefault {
    UIImage *categoriesImage = [[UIImage imageNamed:@"categories"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomTabControllerItem *categoriesItem = [CustomTabControllerItem itemWithTitle:@"Categories" image:categoriesImage block:^BOOL(CustomTabControllerItem *item) {
        CategoriesViewController *vc = [[CategoriesViewController alloc] init];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate changeRootViewController:vc];

        return YES;
    }];

    RouteListViewController *homeController = [[RouteListViewController alloc] init];
    UIImage *homeImage = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomTabControllerItem *homeItem = [CustomTabControllerItem itemWithTitle:@"Home" image:homeImage controller:homeController];

    UIImage *newRouteImage = [[UIImage imageNamed:@"new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomTabControllerItem *newRouteItem = [CustomTabControllerItem itemWithTitle:@"New Route" image:newRouteImage block:^BOOL(CustomTabControllerItem *item) {
        RouteCoverEditViewController *vc = [[RouteCoverEditViewController alloc] init];
        vc.route = [Route emptyRoute];
        [self.navigationController pushViewController:vc animated:YES];

        return YES;
    }];

    ProfileViewController *profileController = [[ProfileViewController alloc] init];
    UIImage *profileImage = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomTabControllerItem *profileItem = [CustomTabControllerItem itemWithTitle:@"Profile" image:profileImage controller:profileController];

    UIImage *logoutImage = [[UIImage imageNamed:@"logout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomTabControllerItem *logoutItem = [CustomTabControllerItem itemWithTitle:@"Logout" image:logoutImage block:^BOOL(CustomTabControllerItem *item) {
        [User forget];

        return YES;
    }];

    homeItem.leftItem = categoriesItem;

    profileItem.leftItem = newRouteItem;
    profileItem.rightItem = logoutItem;

    return [self initWithItems:@[homeItem, profileItem]];
}

- (instancetype) initWithItems:(NSArray<CustomTabControllerItem *> *)items {
    if (self = [super init]) {
        _controllerItems = items;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar = [[YALFoldingTabBar alloc] initWithFrame:self.tabBarView.bounds];
    self.tabBar.delegate = self;
    self.tabBar.dataSource = self;

    NSMutableArray *leftTabBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *rightTabBarItems = [[NSMutableArray alloc] init];
    long middle = floor(self.controllerItems.count / 2);
    long i = 0;
    for (CustomTabControllerItem *item in self.controllerItems) {
        YALTabBarItem *tabBarItem = [[YALTabBarItem alloc] initWithItemImage:item.image
                                                               leftItemImage:item.leftItem ? item.leftItem.image : nil
                                                              rightItemImage:item.rightItem ? item.rightItem.image : nil];

        if (i++ < middle) {
            [leftTabBarItems addObject:tabBarItem];
        } else {
            [rightTabBarItems addObject:tabBarItem];
        }
    }
    self.leftTabBarItems = leftTabBarItems;
    self.rightTabBarItems = rightTabBarItems;

    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:leftTabBarItems];
    [tabBarItems addObjectsFromArray:rightTabBarItems];
    self.tabBarItems = tabBarItems;
    self.tabBar.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
    self.tabBar.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
    self.tabBar.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
    self.tabBar.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
    
    self.tabBarView.backgroundColor = UIColorFromRGB(kDarkPurpleColorHex);
    self.tabBar.backgroundColor = UIColorFromRGB(kDarkPurpleColorHex);
    self.tabBar.tabBarColor = UIColorFromRGB(kLightBlueColorHex);
    self.tabBar.dotColor = [UIColor whiteColor];

    [self.tabBarView addSubview:self.tabBar];

    self.tabBar.selectedTabBarItemIndex = 0;
    [self itemInTabBarViewPressed:self.tabBar atIndex:0];
}

- (void)viewDidLayoutSubviews {
    self.tabBar.frame = self.tabBarView.bounds;
}

- (NSArray *)leftTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView {
    return self.leftTabBarItems;
}

- (NSArray *)rightTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView {
    return self.rightTabBarItems;
}

- (void)extraLeftItemDidPressInTabBarView:(YALFoldingTabBar *)tabBarView {
    CustomTabControllerItem *customItem = self.controllerItems[tabBarView.selectedTabBarItemIndex].leftItem;

    if ([self.controllerItems containsObject:customItem]) {
        self.tabBar.selectedTabBarItemIndex = [self.controllerItems indexOfObject:customItem];
        [self itemInTabBarViewPressed:self.tabBar atIndex:self.tabBar.selectedTabBarItemIndex];
        return;
    }

    [self performActionForItem:customItem];
}

- (void)extraRightItemDidPressInTabBarView:(YALFoldingTabBar *)tabBarView {
    CustomTabControllerItem *customItem = self.controllerItems[tabBarView.selectedTabBarItemIndex].rightItem;

    if ([self.controllerItems containsObject:customItem]) {
        self.tabBar.selectedTabBarItemIndex = [self.controllerItems indexOfObject:customItem];
        [self itemInTabBarViewPressed:self.tabBar atIndex:self.tabBar.selectedTabBarItemIndex];
        return;
    }

    [self performActionForItem:customItem];
}

- (void)itemInTabBarViewPressed:(YALFoldingTabBar *)tabBarView atIndex:(NSUInteger)index {
    CustomTabControllerItem *customItem = self.controllerItems[index];
    [self performActionForItem:customItem];
}

- (UIImage *)centerImageInTabBarView:(YALFoldingTabBar *)tabBarView {
    return [UIImage imageNamed:@"mappin"];
}

- (void) performActionForItem:(CustomTabControllerItem *)item {
    if (item.controller) {
        [self presentController:item.controller];
    } else if (item.block) {
        item.block(item);
    }
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
