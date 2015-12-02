//
//  Route.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "Route.h"

@implementation Route

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _title = dictionary[@"title"];
        _imageUrl = dictionary[@"imageUrl"];
        _author = dictionary[@"author"];
        _fullDescription = dictionary[@"fullDescription"];
    }
    return self;
}

+ (NSArray *)routeWithArray:(NSArray *) array {
    NSMutableArray *routeCategories = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [routeCategories addObject:[[Route alloc] initWithDictionary:dictionary]];
    }
    return routeCategories;
}


@end
