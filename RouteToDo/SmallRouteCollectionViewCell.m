//
//  SmallRouteCollectionViewCell.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/20/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "SmallRouteCollectionViewCell.h"
#import "UIImageView+ProgressIndicator.h"

@interface SmallRouteCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *routeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *routeLocationLabel;
@end

@implementation SmallRouteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRoute:(Route *)route {
    _route = route;
    [self reloadData];
}

- (void)reloadData {
    self.routeTitleLabel.text = self.route.title;
    self.routeLocationLabel.text = self.route.location;
    [self.backgroundImageView setImageWithProgressIndicatorAndURL:self.route.imageUrl completion:nil];
}

@end
