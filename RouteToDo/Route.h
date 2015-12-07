//
//  Route.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "User.h"

@interface Route : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *location;
@property (nonatomic) User *author;
@property (nonatomic) NSString *fullDescription;
@property (nonatomic) NSURL *imageUrl;
@property (nonatomic) NSArray<Place *> *places;
@property (nonatomic) double rating;
@property (nonatomic) long usersCount;
@property (nonatomic) NSArray *categories;
@property (nonatomic) BOOL favorite;

+ (NSArray *)routeWithArray:(NSArray *) array;
+ (Route *)emptyRoute;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
