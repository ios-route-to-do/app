//
//  Category.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteCategory.h"

@implementation RouteCategory

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _name = dictionary[@"name"];
        _imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];
    }
    return self;
}

+ (NSArray *)routeCategoryWithArray:(NSArray *) array {
    NSMutableArray *routeCategories = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [routeCategories addObject:[[RouteCategory alloc] initWithDictionary:dictionary]];
    }
    return routeCategories;
}

@end
