//
//  Route.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "Route.h"

NSString * const RouteFinishedNotification = @"RouteFinishedNotification";
NSString * const RouteFavoritedNotification = @"RouteFavoritedNotification";

@implementation Route

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _routeId = dictionary[@"id"];
        _title = dictionary[@"title"];
        _location = dictionary[@"location"];
        if (![dictionary[@"image_url"] isEqual:[NSNull null]]) {
            _imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];
        }
        _author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        _fullDescription = dictionary[@"full_description"];
        _rating = [dictionary[@"rating"] doubleValue];
        _usersCount = [dictionary[@"outings_count"] longValue];
        _places = [Place placesWithArray:dictionary[@"places"]];

        if (![dictionary[@"favorite"] isEqual:[NSNull null]]) {
            _favorite = [dictionary[@"favorite"] boolValue];
        }
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
