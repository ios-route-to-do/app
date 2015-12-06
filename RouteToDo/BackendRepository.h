//
//  BackendRepository.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/24/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"
#import "Place.h"
#import "User.h"
#import "RouteCategory.h"
#import "Location.h"

@protocol BackendRepository <NSObject>

#pragma mark - Categories

- (void)allCategoriesWithCompletion:(void (^)(NSArray *categories, NSError *error))completion;

#pragma mark - Home routes

- (void)trendingRoutesWithLocation:(Location *)location completion:(void (^)(NSArray *routes, NSError *error))completion;
- (void)newRoutesWithLocation:(Location *)location completion:(void (^)(NSArray *routes, NSError *error))completion;

#pragma mark - User routes

- (void)favoriteRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion;
- (void)userOutingsWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion;
- (void)userRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion;

#pragma mark - Actions

- (void)toggleRouteFavoriteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion;
- (void)finishRouteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion;
- (void)rateRouteWithUser:(User *)user route:(Route *)route rating:(NSNumber *)rating completion:(void (^)(NSError *error))completion;

#pragma mark - User

- (void)registerUserWithEmail:(NSString *)email imageUrl:(NSString *)image completion:(void (^)(User *user, NSError *error))completion;
- (void)loginUserWithEmail:(NSString *)email completion:(void (^)(User *user, NSError *error))completion;

#pragma mark - Routes

- (void)createRouteWithObject:(Route *)route completion:(void (^)(Route *route, NSError *error))completion;

#pragma mark - Upload Media

- (void)storeImageWithData:(NSData *)data completion:(void (^)(NSString *imageUrl, NSError *error))completion;

@end

@interface BackendRepository : NSObject

+ (id<BackendRepository>)sharedInstance;

@end
