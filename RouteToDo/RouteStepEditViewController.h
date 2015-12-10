//
//  RouteStepEditViewController.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface RouteStepEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *routeMapView;

@property (nonatomic) Route *route;
@property (nonatomic) long step;

@end
