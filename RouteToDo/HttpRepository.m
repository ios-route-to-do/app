//
//  HttpRepository.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 12/1/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "HttpRepository.h"
#import "AFNetworking.h"
#import "RouteCategory.h"
#import "Route.h"
#import "User.h"

#ifdef DEBUG
NSString * const kBaseUrl = @"http://localhost:3000";
#else
NSString * const kBaseUrl = @"https://jopp.herokuapp.com";
#endif

@implementation HttpRepository

#pragma mark - Categories

- (void)allCategoriesWithCompletion:(void (^)(NSArray *categories, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/categories"];
    [[self httpManager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful JSON: %@", responseObject);
        NSArray *categories = [RouteCategory routeCategoryWithArray:responseObject];
        completion(categories, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed GET categories : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

#pragma mark - Home routes

- (void)trendingRoutesWithLocation:(Location *)location completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/routes/trending"];
    [[self httpManager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful GET trending routes request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed GET trending routes : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

- (void)newRoutesWithLocation:(Location *)location completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/routes/new"];
    [[self httpManager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful GET new routes request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed GET new routes : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

#pragma mark - User routes

- (void)favoriteRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/users/%@/favorites", user.userId]];
    [[self httpManager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful GET user favorite routes request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed GET favorite routes : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

- (void)userOutingsWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/users/%@/outings", user.userId]];
    [[self httpManager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful GET user outings request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed GET user outings : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

- (void)userRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/users/%@/routes", user.userId]];
    [[self httpManager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successful GET user own routes request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed GET user own routes : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

#pragma mark - Actions

- (void)toggleRouteFavoriteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion {
    NSDictionary *params = @{@"user_id": user.userId};

    if(route.favorite) {
        NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/routes/%@/unfavorite", route.routeId]];

        [[self httpManager] POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"routeUnfavorited" object:self
                                                              userInfo:@{@"route": route}];
            route.favorite = NO;
            completion(nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error POST route unfavorite: %@", [error localizedDescription]);
            completion(error);
        }];
    } else {
        NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/routes/%@/favorite", route.routeId]];

        [[self httpManager] POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"routeFavorited" object:self
                                                              userInfo:@{@"route": route}];
            route.favorite = YES;
            completion(nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error POST route favorite: %@", [error localizedDescription]);
            completion(error);
        }];
    }
}

- (void)finishRouteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/routes/%@/finish", route.routeId]];
    NSDictionary *params = @{@"user_id": user.userId};

    [[self httpManager] POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [user.outings addObject:route];
        [[NSNotificationCenter defaultCenter] postNotificationName:RouteFinishedNotification object:self
                                                          userInfo:@{@"route": route, @"user": user}];
        if (completion) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error finishing route: %@", [error localizedDescription]);
        if (completion) {
            completion(error);
        }
    }];
}

- (void)rateRouteWithUser:(User *)user route:(Route *)route rating:(double)rating completion:(void (^)(NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:[NSString stringWithFormat:@"/routes/%@/rate", route.routeId]];
    NSDictionary *params = @{@"rating": [NSNumber numberWithDouble:rating]};
    [[self httpManager] POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        route.rating = [responseObject[@"rating"] doubleValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"routeRated" object:self
                                                          userInfo:@{@"route": route, @"user": user}];
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error);
    }];
}

#pragma mark - User

- (void)registerUserWithEmail:(NSString *)email imageUrl:(NSString *)image completion:(void (^)(User *user, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/users/register"];

    NSDictionary *params = @{@"email": email};
    [[self httpManager] POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *user = [[User alloc] initWithDictionary:responseObject];
        completion(user,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed POST register user : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

- (void)loginUserWithEmail:(NSString *)email completion:(void (^)(User *user, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/users/login"];

    AFHTTPRequestOperationManager *manager = self.httpManager;
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    NSDictionary *params = @{@"email": email};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *user = [[User alloc] initWithDictionary:responseObject];
        completion(user,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed POST user login : %@",[error localizedDescription]);
        completion(nil, error);
    }];
}

#pragma mark - Routes

- (void)createRouteWithObject:(Route *)route completion:(void (^)(Route *route, NSError *error))completion {
    sleep(3);
    completion(route, nil);
}

#pragma mark - Upload Media

- (void)storeImage:(UIImage *)image completion:(void (^)(NSString *imageUrl, NSError *error))completion {

    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.80)];
    NSString *url = [kBaseUrl stringByAppendingString:@"/images"];

    [[self httpManager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"attachment"
                                fileName:@"RouteImage" mimeType:@"image/jpeg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject[@"image_url"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed POST new image: %@",[error localizedDescription]);
        completion(nil, error);
    }];

}

#pragma mark - Search Places

- (void)searchPlacesWithLocation:(NSString *)location searchQuery:(NSString *)query completion:(void (^)(MKCoordinateRegion region, NSArray<Place *> *places, NSError *error))completion {

    NSDictionary *params = @{@"location": location,
                             @"query": query,
                             @"language": [[NSLocale preferredLanguages] objectAtIndex:0]
                             };

    [self searchPlacesWithParameters:params completion:completion];
}

- (void)searchPlacesWithCoordinates:(CLLocationCoordinate2D)coordinates searchQuery:(NSString *)query completion:(void (^)(MKCoordinateRegion region, NSArray<Place *> *places, NSError *error))completion {

    NSDictionary *params = @{@"latitude": @(coordinates.latitude),
                             @"longitude": @(coordinates.longitude),
                             @"query": query,
                             @"language": [[NSLocale preferredLanguages] objectAtIndex:0]
                             };

    [self searchPlacesWithParameters:params completion:completion];
}

- (void)searchPlacesWithParameters:(NSDictionary *)parameters completion:(void (^)(MKCoordinateRegion region, NSArray<Place *> *places, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/places/search"];

    [[self httpManager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = responseObject;

        CLLocationCoordinate2D regionCenter = CLLocationCoordinate2DMake([response[@"region"][@"center"][@"latitude"] doubleValue], [response[@"region"][@"center"][@"longitude"] doubleValue]);
        MKCoordinateSpan regionDelta = MKCoordinateSpanMake([response[@"region"][@"span"][@"latitude_delta"] doubleValue], [response[@"region"][@"span"][@"longitude_delta"] doubleValue]);
        MKCoordinateRegion region = MKCoordinateRegionMake(regionCenter, regionDelta);

        NSArray<Place *> *places = [Place placesWithArray:response[@"places"]];
        completion(region, places, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed GET places search: %@",[error localizedDescription]);
        MKCoordinateRegion region;
        completion(region, nil, error);
    }];
}

- (AFHTTPRequestOperationManager *) httpManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", [User currentUser].userId] forHTTPHeaderField:@"X-Jopp-User-Id"];

    return manager;
}

@end
