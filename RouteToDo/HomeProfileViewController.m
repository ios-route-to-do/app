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

#include "Utils.h"

@interface HomeProfileViewController () <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (nonatomic) NSArray<CustomTabControllerItem *> *controllerItems;
@property (nonatomic) UIViewController *currentController;

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

    self.tabBar.delegate = self;

    if (IS_OS_8_OR_LATER) {
        self.tabBar.tintColor =[UIColor whiteColor];
    } else {
        self.tabBar.selectedImageTintColor = [UIColor whiteColor];
    }
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
    for (CustomTabControllerItem *item in self.controllerItems) {
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:item.title image:item.image selectedImage:nil];
        [tabBarItems addObject:tabBarItem];
    }
    self.tabBar.items = tabBarItems;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBar.selectedItem = self.tabBar.items[0];
    [self tabBar:self.tabBar didSelectItem:self.tabBar.items[0]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    CustomTabControllerItem *customItem = self.controllerItems[[tabBar.items indexOfObject:item]];
    [self presentController:customItem.controller];
}

/* called when user shows or dismisses customize sheet. you can use the 'willEnd' to set up what appears underneath.
 changed is YES if there was some change to which items are visible or which order they appear. If selectedItem is no longer visible,
 it will be set to nil.
 */

//- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray<UITabBarItem *> *)items __TVOS_PROHIBITED;                     // called before customize sheet is shown. items is current item list
//- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray<UITabBarItem *> *)items __TVOS_PROHIBITED;                      // called after customize sheet is shown. items is current item list
//- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray<UITabBarItem *> *)items changed:(BOOL)changed __TVOS_PROHIBITED; // called before customize sheet is hidden. items is new item list
//- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray<UITabBarItem *> *)items changed:(BOOL)changed __TVOS_PROHIBITED;  // called after customize sheet is hidden. items is new item list


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
