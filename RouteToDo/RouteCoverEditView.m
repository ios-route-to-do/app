//
//  RouteCoverEditView.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteCoverEditView.h"

const long RouteDescriptionMaxLength = 200;

@interface RouteCoverEditView() <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

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
    self.routeDescriptionTextView.text = route.fullDescription;

    long length = route.fullDescription.length;
    if (length > RouteDescriptionMaxLength) {
        length = RouteDescriptionMaxLength;
    }

    self.routeDescriptionTextView.delegate = self;
    self.countLabel.text = [NSString stringWithFormat:@"%ld / %ld", length, RouteDescriptionMaxLength];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.countLabel.text = [NSString stringWithFormat:@"%ld / %ld", textView.text.length, RouteDescriptionMaxLength];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger insertDelta = text.length - range.length;
    return (!(textView.text.length + insertDelta > RouteDescriptionMaxLength));
}
- (IBAction)onSaveButtonTap:(UIButton *)sender {
    if (self.delegate) {
        [self updateRouteWithValues];
        [self.delegate routeCoverEditView:self didSaveRoute:self.route];
    }
}

- (IBAction)onCancelButtonTap:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate routeCoverEditView:self didCancelEditingRoute:self.route];
    }
}

- (void) updateRouteWithValues {
    self.route.title = self.routeTitleTextField.text;
    self.route.location = self.routeLocationTextField.text;
    self.route.fullDescription = self.routeDescriptionTextView.text;
}

@end
