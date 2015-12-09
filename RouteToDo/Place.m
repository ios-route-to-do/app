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
    if (dictionary[@"coordinates"] != nil) {
        place.coordinates = CLLocationCoordinate2DMake([dictionary[@"coordinates"][@"latitude"] doubleValue], [dictionary[@"coordinates"][@"longitude"] doubleValue]);
    } else {
        place.coordinates = CLLocationCoordinate2DMake([dictionary[@"lat"] doubleValue], [dictionary[@"lng"] doubleValue]);
    }
    place.location = dictionary[@"location"];
    place.address = dictionary[@"address"];
    place.imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];

    return place;
}

- (NSDictionary *)newPlaceObjectForBackend {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"name"] = self.name;
    dictionary[@"full_description"] = self.fullDescription;
    dictionary[@"location"] = self.location;
    dictionary[@"address"] = self.address;
    dictionary[@"image_url"] = [self.imageUrl absoluteString];
    dictionary[@"lat"] = @(self.coordinates.latitude);
    dictionary[@"lng"] = @(self.coordinates.longitude);

    return dictionary;
}

@end
