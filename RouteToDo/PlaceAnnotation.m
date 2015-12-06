//
//  PlaceAnnotation.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/20/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation 

- (instancetype)initWithPlace:(Place *)place step:(long)step {
    if (self = [super init]) {
        _place = place;
        _title = place.name;
        _step = step;
        _coordinate = place.coordinates;
    }
    
    return self;
}


- (UIImage *)pinImage {
    return [self pinWithStep:_step pressed:_selected];
}

- (UIImage *)pinWithStep:(long)step pressed:(BOOL)pressed {
    UIImage *image = [UIImage imageNamed:(pressed ? @"pin_0_pressed" : @"pin_0")];
    UIFont *font = [UIFont boldSystemFontOfSize:9];
    NSString *text = [NSString stringWithFormat:@"%ld", step];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1.5, 1.5);
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowBlurRadius = 2;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSKernAttributeName: @(1.0),
                                 NSShadowAttributeName: shadow,
                                 };

    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];

    CGSize expectedLabelSize = [text sizeWithAttributes:attributes];
    CGRect rect = CGRectMake((image.size.width / 2) - (expectedLabelSize.width / 2) + 1,
                             6,
                             image.size.width,
                             image.size.height);

    [text drawInRect:rect withAttributes:attributes];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}


@end
