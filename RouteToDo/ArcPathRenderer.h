//
//  ArcPathRenderer.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/22/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <MapKit/MapKit.h>

static inline double radians (double degrees) { return degrees * M_PI/180; }

@interface ArcPathRenderer :  MKOverlayPathRenderer

- (instancetype)initWithPolyline:(MKPolyline *)polyline;

@end
