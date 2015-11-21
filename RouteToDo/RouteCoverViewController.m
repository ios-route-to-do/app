//
//  RouteCoverViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteCoverViewController.h"
#import "RouteStepViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface RouteCoverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startRouteButton;

@end

@implementation RouteCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    //Transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Right Buttons
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:0 target:self action:@selector(onShareButtonTap)];

    UIImage *likeImage = [[UIImage imageNamed:@"fav_inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *btnLike = [[UIBarButtonItem alloc] initWithImage:likeImage style:0 target:self action:@selector(onLikeButtonTap)];
    [self.navigationItem setRightBarButtonItems:@[btnShare, btnLike]];
    
    self.startRouteButton.layer.cornerRadius = self.startRouteButton.frame.size.height / 2;
    self.startRouteButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) onShareButtonTap {
    
}

- (void) onLikeButtonTap {
    
}

- (IBAction)onStartRouteButtonTap:(UIButton *)sender {
    RouteStepViewController *rsvc = [[RouteStepViewController alloc] init];
    [self.navigationController pushViewController:rsvc animated:YES];
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
