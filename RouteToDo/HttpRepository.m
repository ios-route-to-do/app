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

NSString * const kBaseUrl = @"http://localhost:3000";

@implementation HttpRepository

#pragma mark - Categories

- (void)allCategoriesWithCompletion:(void (^)(NSArray *categories, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/categories"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful request");
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
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/trending_routes"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)newRoutesWithLocation:(Location *)location completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/new_routes"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        completion(nil, error);
    }];
    
    [operation start];
}

#pragma mark - User routes

- (void)favoriteRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/favorite_routes"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)userOutingsWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/outing_routes"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)userRoutesWithUser:(User *)user completion:(void (^)(NSArray *routes, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/routes"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful request");
        NSArray *routes = [Route routeWithArray:responseObject];
        completion(routes, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        completion(nil, error);
    }];
    
    [operation start];
}

#pragma mark - Actions

- (void)toggleRouteFavoriteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/routes"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"route[description]": route.description,
                             @"user[id]": user.username};
    [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)untoggleRouteFavoriteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/routes"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"route[description]": route.description,
                             @"user[id]": user.username};
    [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)finishRouteWithUser:(User *)user route:(Route *)route completion:(void (^)(NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/routes"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"route[description]": route.description,
                             @"user[id]": user.username};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)rateRouteWithUser:(User *)user route:(Route *)route rating:(NSNumber *)rating completion:(void (^)(NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/routes/rating"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"route[description]": route.description,
                             @"user[id]": user.username};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - User

- (void)registerUserWithEmail:(NSString *)email password:(NSString *)password imageUrl:(NSString *)image completion:(void (^)(User *user, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/register"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user[password]": password,
                             @"user[email]": email};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        User *user = [[User alloc] initWithDictionary:responseObject];
        completion(user,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
}

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(User *user, NSError *error))completion {
    NSString *url = [kBaseUrl stringByAppendingString:@"/v1/user/login"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Sucessful request");
        User *user = [[User alloc] initWithDictionary:responseObject];
        completion(user, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        completion(nil, error);
    }];
    
    [operation start];

}

#pragma mark - Routes

- (void)createRouteWithObject:(Route *)route completion:(void (^)(Route *route, NSError *error))completion {
    
}

#pragma mark - Upload Media

- (void)storeImageWithData:(NSData *)data completion:(void (^)(NSString *imageUrl, NSError *error))completion {
    
}

@end
