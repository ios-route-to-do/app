//
//  LargeRouteCollectionViewCell.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "LargeRouteCollectionViewCell.h"
//#import <UIImageView+AFNetworking.h>

@implementation LargeRouteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRoute:(Route *)route {
    _route = route;
    [self reloadData];
}

- (void)reloadData {

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomTap:)];
//    self.userProfileImageView.userInteractionEnabled = true;
//    [self.userProfileImageView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)onCustomTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.delegate didTapRouteCell:self];
}


@end
