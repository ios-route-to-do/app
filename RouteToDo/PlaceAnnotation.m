//
//  PlaceAnnotation.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/20/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation

- (instancetype)initWithPlace:(Place *)place {
    if (self = [super init]) {
        _place = place;
        _title = place.name;
        _coordinate = place.coordinates;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"PlaceAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"mappin"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end
