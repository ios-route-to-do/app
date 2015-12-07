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

@property (nonatomic) Route *route;
@property (nonatomic) NSNumber *step;

@end
