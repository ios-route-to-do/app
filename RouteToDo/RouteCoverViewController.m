//
//  RouteCoverViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteCoverViewController.h"
#import "RouteStepViewController.h"
#import "BackendRepository.h"
#import "UIImageView+ProgressIndicator.h"

@interface RouteCoverViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startRouteButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesListLabel;

@property (nonatomic) RouteStepViewController *nextStepController;
@property (nonatomic) UIBarButtonItem *likeButton;

@end

@implementation RouteCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    self.nextStepController = nil;
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

    [self updateLikeButton:self.route.favorite animated:NO];
    [self.navigationItem setRightBarButtonItems:@[btnShare, self.likeButton]];
    
    self.startRouteButton.layer.cornerRadius = self.startRouteButton.frame.size.height / 2;
    self.startRouteButton.layer.masksToBounds = YES;

    if (self.route != nil) {
        [self loadDataFromRoute:self.route];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) onShareButtonTap {
    NSString *textToShare = [NSString stringWithFormat:@"Check Jopp https://jopp.herokuapp.com/routes/%@ %@", self.route.routeId, self.route.title];
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (void) onLikeButtonTap {
    id<BackendRepository> repository = [BackendRepository sharedInstance];
    [repository toggleRouteFavoriteWithUser:[User currentUser] route:self.route completion:^(NSError *error) {
        if(error) {
            return;
        }

        [self updateLikeButton:self.route.favorite animated:YES];
    }];
}

- (IBAction)onStartRouteButtonTap:(UIButton *)sender {
    if (self.nextStepController == nil) {
        self.nextStepController = [[RouteStepViewController alloc] init];
        self.nextStepController.route = self.route;
        self.nextStepController.step = 0;
    }

    [self.navigationController pushViewController:self.nextStepController animated:YES];
}

- (void)loadDataFromRoute:(Route *)route {
    [self.imageImageView setImageWithProgressIndicatorAndURL:route.imageUrl completion:nil];
    self.titleLabel.text = route.title;
    self.locationAuthorLabel.text = [NSString stringWithFormat:@"%@ \u2022 By @%@", route.location, route.author.username];
    self.informationLabel.text = [NSString stringWithFormat:@"+%ld users \u2022 %.1f rating", route.usersCount, route.rating];
    self.descriptionLabel.text = route.fullDescription;
    
    NSMutableArray *placesNames = [[NSMutableArray alloc] init];
    for (Place *place in route.places) {
        [placesNames addObject:place.name];
    }
    self.placesListLabel.text = [placesNames componentsJoinedByString:@" \u2022 "];
}

- (void) updateLikeButton:(BOOL)favorite animated:(BOOL)animated {
    UIImage *likeImage = [[UIImage imageNamed:(favorite ? @"fav_active" : @"fav_inactive")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    if (self.likeButton == nil) {
        UIImageView *image = [[UIImageView alloc] initWithImage:likeImage];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = image.bounds;
        [button addSubview:image];
        [button addTarget:self action:@selector(onLikeButtonTap) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        UIImageView *image = [self.likeButton.customView.subviews firstObject];
        image.image = likeImage;
    }
    
    if (animated) {
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulseAnimation.duration = 0.15;
        pulseAnimation.toValue = [NSNumber numberWithFloat:1.5];;
        pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulseAnimation.autoreverses = YES;
        pulseAnimation.repeatCount = 1;
        
        [self.likeButton.customView.layer addAnimation:pulseAnimation forKey:@"scaleAnimation"];
    }
}

@end
