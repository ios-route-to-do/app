//
//  RouteCoverEditView.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface RouteCoverEditView : UIView

@property (nonatomic) Route *route;

- (void) updateRouteWithValues;

@end
