//
//  PlaceAnnotation.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/20/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface PlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) Place *place;
@property (nonatomic, readonly) long step;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) BOOL selected;

- (instancetype) initWithPlace:(Place *)place step:(long)step;
- (UIImage *)pinImage;

@end
