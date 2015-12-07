//
//  Place.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "Place.h"

@implementation Place

+ (NSArray<Place *> *) placesWithArray:(NSArray *)array {
    NSMutableArray *places = [[NSMutableArray alloc] init];

    for (NSDictionary *placeData in array) {
        Place *place = [[Place alloc] initWithDictionary:placeData];
        [places addObject:place];
    }

    return places;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    Place *place = [[Place alloc] init];

    place.name = dictionary[@"name"];
    place.fullDescription = dictionary[@"full_description"];
    place.coordinates = CLLocationCoordinate2DMake([dictionary[@"coordinates"][@"latitude"] doubleValue], [dictionary[@"coordinates"][@"longitude"] doubleValue]);
    place.location = dictionary[@"location"];
    place.address = dictionary[@"address"];
    place.imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];

    return place;
}

@end
