//
//  ParseRepository.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
#import "Place.h"
#import "User.h"
#import "RouteCategory.h"
#import "Location.h"

@interface ParseRepository : NSObject

#pragma mark - Categories

- (void)allCategoriesWithCompletion:(void (^)(NSArray *routes, NSError *error))completion;

#pragma mark - Home routes

- (void)trendingRoutesWithPlace:(Place *)place completion:(void (^)(NSArray *routes, NSError *error))completion;
- (void)newRoutesWithPlace:(Place *)place completion:(void (^)(NSArray *routes, NSError *error))completion;

#pragma mark - User routes

- (void)favoriteRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion;
- (void)userOutingsWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion;
- (void)userRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion;

#pragma mark - Actions

- (void)markRouteAsFavoriteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSArray *routes, NSError *error))completion;
- (void)rateRouteWithUser:(User *)user route:(Route *)route rating:(NSNumber *)rating completion:(void (^)(NSArray *routes, NSError *error))completion;


@end
