//
//  PlaceEditView.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@class PlaceEditView;

@protocol PlaceEditViewDelegate <NSObject>

@required
- (void)placeEditView:(PlaceEditView *)view didSavePlace:(Place *)place;
- (void)placeEditView:(PlaceEditView *)view didCancelEditingPlace:(Place *)place;

@end

@interface PlaceEditView : UIView

@property (nonatomic) Place *place;

@property (weak, nonatomic) IBOutlet UITextField *placeNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *placeDescriptionTextView;

@property (weak, nonatomic) id<PlaceEditViewDelegate> delegate;

- (void) updatePlaceWithValues;

@end
