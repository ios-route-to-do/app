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

@end

@implementation LargeRouteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRoute:(Route *)route {
    _route = route;
    [self reloadData];
}

- (void)reloadData {
    self.routeTitle.text = self.route.title;
    self.routeLocationLabel.text = self.route.location;
    self.routeAuthorLabel.text = [NSString stringWithFormat:@"• By %@", self.route.author];
    self.routeUsersLabel.text = [NSString stringWithFormat:@"+%@", self.route.usersCount];
    self.routeRatingLable.text = @"• 5.0 rating";
    [self.backgroundImageView setImageWithURL:self.route.imageUrl];
}
- (IBAction)onLikeButton:(id)sender {
    NSLog(@"like route");
}

@end
