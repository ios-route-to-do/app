//
//  Route.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "Route.h"

NSString * const RouteFinishedNotification = @"RouteFinishedNotification";
NSString * const RouteFavoritedNotification = @"RouteFinishedNotification";

@implementation Route

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _routeId = dictionary[@"id"];
        _title = dictionary[@"title"];
        _location = dictionary[@"location"];
        _imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];
        _author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        _fullDescription = dictionary[@"full_description"];
        if (!(dictionary[@"rating"] == (id)[NSNull null])) {
            _rating = [dictionary[@"rating"] doubleValue];
        }
        _places = [Place placesWithArray:dictionary[@"places"]];
        _favorite = [dictionary[@"favorite"] boolValue];
    }
    return self;
}

- (NSDictionary *)newRouteObjectForBackend {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"title"] = self.title;
    dictionary[@"location"] = self.location;
    dictionary[@"full_description"] = self.fullDescription;
    dictionary[@"image_url"] = [self.imageUrl absoluteString];
    dictionary[@"user_id"] = self.author.userId;
    dictionary[@"places"] = [NSMutableArray array];
    for (Place *place in self.places) {
        [dictionary[@"places"] addObject:[place newPlaceObjectForBackend]];
    }

    return dictionary;
}

+ (NSArray *)routeWithArray:(NSArray *) array {
    NSMutableArray *routes = [NSMutableArray array];

    for (NSDictionary *dictionary in array) {
        [routes addObject:[[Route alloc] initWithDictionary:dictionary]];
    }
    return routes;
}

+ (Route *)emptyRoute {
    Route *route = [[Route alloc] init];
    route.author = [User currentUser];
    route.places = @[
                     [[Place alloc] init],
                     [[Place alloc] init],
                     [[Place alloc] init]
                     ];

    return route;
}

@end
