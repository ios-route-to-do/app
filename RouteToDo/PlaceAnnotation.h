//
//  PlaceAnnotation.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/20/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

- (instancetype) initWithTitle:(NSString *)title andLocation:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end
