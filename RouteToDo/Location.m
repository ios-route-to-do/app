//
//  Location.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "Location.h"

@implementation Location

@dynamic name;
@dynamic coordinates;
@dynamic radius;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Location";
}

@end
