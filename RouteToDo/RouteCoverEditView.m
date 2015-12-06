//
//  RouteCoverEditView.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteCoverEditView.h"

@interface RouteCoverEditView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *routeTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *routeLocationTextField;
@property (weak, nonatomic) IBOutlet UITextView *routeDescriptionTextView;

@end

@implementation RouteCoverEditView

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

- (void) initSubviews {
    UINib *nib = [UINib nibWithNibName:@"RouteCoverEditView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (void)setRoute:(Route *)route {
    _route = route;
    self.routeTitleTextField.text = route.title;
    self.routeLocationTextField.text = route.location;
    self.routeTitleTextField.text = route.fullDescription;
}

- (void) updateRouteWithValues {
    self.route.title = self.routeTitleTextField.text;
    self.route.location = self.routeLocationTextField.text;
    self.route.fullDescription = self.routeTitleTextField.text;
}

@end
