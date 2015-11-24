//
//  LargeRouteCollectionViewCell.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "LargeRouteCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface LargeRouteCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *routeTitle;
@property (weak, nonatomic) IBOutlet UILabel *routeLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeRatingLable;
@property (weak, nonatomic) IBOutlet UILabel *routeUsersLabel;
@property (weak, nonatomic) IBOutlet UIButton *routeLikeButton;
@property (strong, nonatomic) UIImageView *likeImageView;

@end

@implementation LargeRouteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRoute:(Route *)route {
    _route = route;
    NSLog(@"%@", route);
    [self reloadData];
}

- (void)reloadData {
    self.routeTitle.text = self.route.title;
    self.routeLocationLabel.text = self.route.location;
    self.routeAuthorLabel.text = [NSString stringWithFormat:@"• By %@", self.route.author];
    self.routeUsersLabel.text = [NSString stringWithFormat:@"+%@", self.route.usersCount];
    self.routeRatingLable.text = @"• 5.0 rating";
    [self.backgroundImageView setImageWithURL:self.route.imageUrl];
    [self updateLikeButton:self.route.favorite animated:NO];
}

- (IBAction)onLikeButton:(id)sender {
    bool originalValue = self.route.favorite;
    
    void (^completion)(NSError *error) = ^(NSError *error) {
        if (error) {
            [self updateLikeButton:originalValue animated:NO];
        }
    };
    
    if (self.route.favorite) {
        [self updateLikeButton:NO animated:YES];
        [self.route unfavoriteWithCompletion:completion];
    } else {
        [self updateLikeButton:YES animated:YES];
        [self.route favoriteWithCompletion:completion];
    }
}

- (void) updateLikeButton:(BOOL)favorite animated:(BOOL)animated {
    UIImage *likeImage = [[UIImage imageNamed:(favorite ? @"fav_active" : @"fav_inactive")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    if (!self.likeImageView) {
        self.likeImageView = [[UIImageView alloc] initWithImage:likeImage];
        self.likeImageView.bounds = self.routeLikeButton.bounds;
        [self.routeLikeButton addSubview:self.likeImageView];
    }
    self.likeImageView.image = likeImage;
    
    if (animated) {
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulseAnimation.duration = 0.15;
        pulseAnimation.toValue = [NSNumber numberWithFloat:1.5];;
        pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulseAnimation.autoreverses = YES;
        pulseAnimation.repeatCount = 1;
        
        [self.likeImageView.layer addAnimation:pulseAnimation forKey:@"scaleAnimation"];
    }
}


@end
