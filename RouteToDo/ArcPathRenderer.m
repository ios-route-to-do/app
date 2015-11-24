//
//  ArcPathRenderer.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/22/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "ArcPathRenderer.h"

@interface ArcPathRenderer()

@property (nonatomic) MKPolyline *polyline;

@end

@implementation ArcPathRenderer

- (instancetype)initWithPolyline:(MKPolyline *)polyline {
    if (self = [super init]) {
        _polyline = polyline;
    }
    
    return self;
}

- (void)createPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint point1 = [self pointForMapPoint:self.polyline.points[0]];
    CGPoint point2 = [self pointForMapPoint:self.polyline.points[1]];

    CGFloat b = (point2.y - point1.y) / (point2.x - point1.x),
    i = (point1.x + point2.x) / 2,
    j = (point1.y + point2.y) / 2,
    c = j + i/b,
    l = MIN(point1.y, point2.y),
    k = b*(c-l);
    
    CGPathMoveToPoint(path, NULL, point1.x, point1.y);
    CGPathAddQuadCurveToPoint(path, NULL, k, l, point2.x, point2.y);
    
    self.path = CGPathCreateCopy(path);
}

@end
