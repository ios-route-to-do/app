//
//  PlaceAnnotation.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/20/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation

- (instancetype)initWithTitle:(NSString *)title andLocation:(CLLocationCoordinate2D)location {
    if (self = [super init]) {
        _title = title;
        _coordinate = location;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"PlaceAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"location"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end
