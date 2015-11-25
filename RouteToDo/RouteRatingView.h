//
//  RouteRatingView.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/24/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@class RouteRatingView;

@protocol RouteRatingControlDelegate <NSObject>

- (void)didTapCancel;
- (void)didTapSubmitWithRating:(NSNumber *) rating;

@end

@interface RouteRatingView : UIView

@property (nonatomic) Route *route;
@property (weak, nonatomic) id<RouteRatingControlDelegate> delegate;

@end
