//
//  PlaceEditView.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "PlaceEditView.h"

const long PlaceDescriptionMaxLength = 200;

@interface PlaceEditView() <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation PlaceEditView

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
    UINib *nib = [UINib nibWithNibName:@"PlaceEditView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (void)setPlace:(Place *)place {
    _place = place;
    self.placeNameTextField.text = place.name;
    self.placeDescriptionTextView.text = place.fullDescription;

    long length = place.fullDescription.length;
    if (length > PlaceDescriptionMaxLength) {
        length = PlaceDescriptionMaxLength;
    }

    self.placeDescriptionTextView.delegate = self;
    self.countLabel.text = [NSString stringWithFormat:@"%ld / %ld", length, PlaceDescriptionMaxLength];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.countLabel.text = [NSString stringWithFormat:@"%ld / %ld", textView.text.length, PlaceDescriptionMaxLength];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger insertDelta = text.length - range.length;
    return (!(textView.text.length + insertDelta > PlaceDescriptionMaxLength));
}
- (IBAction)onSaveButtonTap:(UIButton *)sender {
    if (self.delegate) {
        [self updatePlaceWithValues];
        [self.delegate placeEditView:self didSavePlace:self.place];
    }
}

- (IBAction)onCancelButtonTap:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate placeEditView:self didCancelEditingPlace:self.place];
    }
}

- (void) updatePlaceWithValues {
    self.place.name = self.placeNameTextField.text;
    self.place.fullDescription = self.placeDescriptionTextView.text;
}

@end
