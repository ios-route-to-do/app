//
//  RouteRatingView.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/24/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteRatingView.h"
#import "HCSStarRatingView.h"

@interface RouteRatingView()

@property (nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingControl;

@end

@implementation RouteRatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setRoute:(Route *)route {
    _route = route;

    self.titleLabel.text = route.title;
    self.locationLabel.text = route.location;
    self.authorLabel.text = [NSString stringWithFormat:@"• By %@", route.author.username];
}

- (void) initSubviews {
    UINib *nib = [UINib nibWithNibName:@"RouteRatingView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (IBAction)onCancelTap:(id)sender {
    [self.delegate routeRatingView:self didTapCancelWithRating:self.ratingControl.value];
}

- (IBAction)onSubmitTap:(id)sender {
    [self.delegate routeRatingView:self didTapSubmitWithRating:self.ratingControl.value];
}

@end
