//
//  PlaceEditView.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "PlaceEditView.h"
#import "Utils.h"

const long PlaceDescriptionMaxLength = 200;

@interface PlaceEditView() <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic) UILabel *placeHolderText;

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
    [self textViewDidEndEditing:self.placeDescriptionTextView];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.countLabel.text = [NSString stringWithFormat:@"%ld / %ld", textView.text.length, PlaceDescriptionMaxLength];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger insertDelta = text.length - range.length;

    if (insertDelta > 0 && self.placeHolderText) {
        [self.placeHolderText removeFromSuperview];
    } else if (textView.text.length + insertDelta == 0) {
        [self addPlaceHolderToTextView:textView];
    }

    return (!(textView.text.length + insertDelta > PlaceDescriptionMaxLength));
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [self addPlaceHolderToTextView:textView];
    }
    [textView resignFirstResponder];
}

- (void) addPlaceHolderToTextView:(UITextView *)textView {
    if (!self.placeHolderText) {
        self.placeHolderText = [[UILabel alloc] initWithFrame:CGRectMake(4, 8, 30, 20)];
        self.placeHolderText.font = textView.font;
        self.placeHolderText.text = @"(Place description)";
        self.placeHolderText.textColor = UIColorFromRGB(kPlaceHolderColor);
        [self.placeHolderText sizeToFit];
    }

    [textView addSubview:self.placeHolderText];
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
