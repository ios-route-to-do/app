//
//  RouteRatingView.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/24/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RouteRatingView : UIView

@property (weak, nonatomic) IBOutlet UILabel *routeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeAuthorLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *actionsControl;

@end
