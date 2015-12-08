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

- (instancetype) initWithItems:(NSArray<CustomTabControllerItem *> *)items {
    if (self = [super init]) {
        _controllerItems = items;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect tabBarFrame = CGRectMake(8, 8, self.tabBarView.bounds.size.width - 16, self.tabBarView.bounds.size.height - 24);
    self.tabBar = [[YALFoldingTabBar alloc] initWithFrame:tabBarFrame];
    self.tabBar.delegate = self;
    self.tabBar.dataSource = self;

    NSMutableArray *leftTabBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *rightTabBarItems = [[NSMutableArray alloc] init];
    long middle = floor(self.controllerItems.count / 2);
    long i = 0;
    for (CustomTabControllerItem *item in self.controllerItems) {
        YALTabBarItem *tabBarItem = [[YALTabBarItem alloc] initWithItemImage:item.image
                                                          leftItemImage:nil
                                                         rightItemImage:nil];

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
    [self.tabBarView addSubview:self.tabBar];

    self.tabBarView.backgroundColor = UIColorFromRGB(kDarkPurpleColorHex);
    self.tabBar.backgroundColor = UIColorFromRGB(kDarkPurpleColorHex);
    self.tabBar.tabBarColor = UIColorFromRGB(kLightBlueColorHex);
    self.tabBar.dotColor = UIColorFromRGB(kLightBlueColorHex);
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBar.selectedTabBarItemIndex = 0;
    [self itemInTabBarViewPressed:self.tabBar atIndex:0];
}

- (NSArray *)leftTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView {
    return self.leftTabBarItems;
}

- (NSArray *)rightTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView {
    return self.rightTabBarItems;
}

- (void)itemInTabBarViewPressed:(YALFoldingTabBar *)tabBarView atIndex:(NSUInteger)index {
    CustomTabControllerItem *customItem = self.controllerItems[index];
    [self presentController:customItem.controller];
}

- (UIImage *)centerImageInTabBarView:(YALFoldingTabBar *)tabBarView {
    return [UIImage imageNamed:@"mappin"];
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
