//
//  RouteCoverEditView.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@class RouteCoverEditView;

@protocol RouteCoverEditViewDelegate <NSObject>

@required
- (void)routeCoverEditView:(RouteCoverEditView *)view didSaveRoute:(Route *)route;
- (void)routeCoverEditView:(RouteCoverEditView *)view didCancelEditingRoute:(Route *)route;

@end

@interface RouteCoverEditView : UIView

@property (nonatomic) Route *route;

@property (weak, nonatomic) IBOutlet UITextField *routeTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *routeLocationTextField;
@property (weak, nonatomic) IBOutlet UITextView *routeDescriptionTextView;

@property (weak, nonatomic) id<RouteCoverEditViewDelegate> delegate;

- (void) updateRouteWithValues;

@end
