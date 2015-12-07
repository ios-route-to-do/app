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
#import "mocks.h"

NSString * const kBaseUrl = @"http://localhost:3000";

@implementation HttpRepository

#pragma mark - Categories

- (void)allCategoriesWithCompletion:(void (^)(NSArray *categories, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/categories"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful JSON: %@", responseObject);
        NSArray *categories = [RouteCategory routeCategoryWithArray:responseObject];
        completion(categories, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        completion(nil, error);
    }];
    
    [operation start];
}

#pragma mark - Home routes

- (void)trendingRoutesWithLocation:(Location *)location completion:(void (^)(NSArray *routes, NSError *error))completion {
    completion(mockRouteWithouthPlaces1Array(), nil);
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/trending_routes"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Sucessful request");
//        NSArray *routes = [Route routeWithArray:responseObject];
//        completion(routes, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAILED request");
//        completion(nil, error);
//    }];
//    
//    [operation start];
}

- (void)newRoutesWithLocation:(Location *)location completion:(void (^)(NSArray *routes, NSError *error))completion {
    completion(mockRouteWithouthPlaces2Array(), nil);
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/new_routes"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Sucessful request");
//        NSArray *routes = [Route routeWithArray:responseObject];
//        completion(routes, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAILED request");
//        completion(nil, error);
//    }];
//    
//    [operation start];
}

#pragma mark - User routes

- (void)favoriteRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    completion(mockRouteWithouthPlaces1Array(), nil);
//    completion(user.favoriteRoutes, nil);
    
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/favorite_routes"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Sucessful request");
//        NSArray *routes = [Route routeWithArray:responseObject];
//        completion(routes, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAILED request");
//        completion(nil, error);
//    }];
//    
//    [operation start];
}

- (void)userOutingsWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
//    completion(user.outings, nil);
    completion(mockRouteWithouthPlaces2Array(), nil);
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/outing_routes"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Sucessful request");
//        NSArray *routes = [Route routeWithArray:responseObject];
//        completion(routes, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAILED request");
//        completion(nil, error);
//    }];
//    
//    [operation start];
}

- (void)userRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    completion(user.ownRoutes, nil);
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/routes"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Sucessful request");
//        NSArray *routes = [Route routeWithArray:responseObject];
//        completion(routes, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAILED request");
//        completion(nil, error);
//    }];
//    
//    [operation start];
}

#pragma mark - Actions

- (void)toggleRouteFavoriteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion {
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/routes"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"route[description]": route.description,
//                             @"user[id]": user.username};
    
    if(route.favorite) {
        route.favorite = false;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"routeUnfavorited" object:self
                                                          userInfo:@{@"route": route}];
//        [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"JSON: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
    } else {
        route.favorite = true;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"routeFavorited" object:self
                                                          userInfo:@{@"route": route}];
        //    [manager POST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"Error: %@", error);
        //    }];

    }
    completion(nil);
}

- (void)finishRouteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion {
    [user.outings addObject:route];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"routeFinished" object:self
                                                      userInfo:@{@"route": route, @"user": user}];
    completion(nil);
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/routes"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"route[description]": route.description,
//                             @"user[id]": user.username};
//    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

- (void)rateRouteWithUser:(User *)user route:(Route *)route rating:(double)rating completion:(void (^)(NSError *error))completion {
    route.rating = rating; // naive implementation for now
    [[NSNotificationCenter defaultCenter] postNotificationName:@"routeRated" object:self
                                                      userInfo:@{@"route": route, @"user": user}];
    completion(nil);
//    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/routes/rating"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"route[description]": route.description,
//                             @"user[id]": user.username};
//    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
}

#pragma mark - User

- (void)registerUserWithEmail:(NSString *)email imageUrl:(NSString *)image completion:(void (^)(User *user, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/users/register"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"email": email};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *user = [[User alloc] initWithDictionary:responseObject];
        completion(user,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

- (void)loginUserWithEmail:(NSString *)email completion:(void (^)(User *user, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/users/login"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"email": email};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *user = [[User alloc] initWithDictionary:responseObject];
        completion(user,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

#pragma mark - Routes

- (void)createRouteWithObject:(Route *)route completion:(void (^)(Route *route, NSError *error))completion {
    
}

#pragma mark - Upload Media

- (void)storeImage:(UIImage *)image completion:(void (^)(NSString *imageUrl, NSError *error))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.80)];
    NSString *url = [kBaseUrl stringByAppendingString:@"/images"];

    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"attachment"
                                fileName:@"RouteImage" mimeType:@"image/jpeg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject[@"image_url"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = responseObject;

        CLLocationCoordinate2D regionCenter = CLLocationCoordinate2DMake([response[@"region"][@"center"][@"latitude"] doubleValue], [response[@"region"][@"center"][@"longitude"] doubleValue]);
        MKCoordinateSpan regionDelta = MKCoordinateSpanMake([response[@"region"][@"span"][@"latitude_delta"] doubleValue], [response[@"region"][@"span"][@"longitude_delta"] doubleValue]);
        MKCoordinateRegion region = MKCoordinateRegionMake(regionCenter, regionDelta);

        NSArray<Place *> *places = [Place placesWithArray:response[@"places"]];
        completion(region, places, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        MKCoordinateRegion region;
        completion(region, nil, error);
    }];
}

@end
