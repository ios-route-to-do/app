//
//  Category.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteCategory.h"

@implementation RouteCategory

@dynamic name;
@dynamic imageUrl;
@dynamic routes;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"RouteCategory";
}

@end
