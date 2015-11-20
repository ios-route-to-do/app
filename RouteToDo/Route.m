//
//  Route.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "Route.h"

@implementation Route

@dynamic title;
@dynamic location;
@dynamic author;
@dynamic fullDescription;
@dynamic imageUrl;
@dynamic places;
@dynamic usersCount;
@dynamic categories;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Route";
}


@end
