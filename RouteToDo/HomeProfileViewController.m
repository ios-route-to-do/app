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

@interface HomeProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) RouteListViewController *routeListViewController;
@property (weak, nonatomic) ProfileViewController *profileViewController;

@end

@implementation HomeProfileViewController

- (id)init {
    self = [super init];

    if (self) {
        NSLog(@"home profile init");
        RouteListViewController *routeListVC = [[RouteListViewController alloc] init];
        self.routeListViewController = routeListVC;
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        self.profileViewController = profileVC;
        
//        UITabBar *tabBar = tabBarController.tabBar;
//        UITabBar *myTabBar = [[UITabBar alloc] init];
//        UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
//        UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
        
//        tabBarItem1.title = @"Home";
//        tabBarItem2.title = @"Profile";
 
//        self.tabBar = myTabBar;
        
//        [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"home_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
//        [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"maps_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"maps.png"]];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[routeListVC, profileVC];
        
//        self.navigationController.  rootViewController = tabBarController;
        
        //        [self.window makeKeyAndVisible];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
