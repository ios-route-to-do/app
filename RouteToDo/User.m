//
//  User.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "User.h"
#import "Route.h"

NSString * const UserMissingNotification = @"UserMissingNotification";
NSString * const UserPresentNotification = @"UserPresentNotification";

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        _userId = dictionary[@"id"];
        _username = dictionary[@"username"];
        _location = dictionary[@"location"];
        _firstName = dictionary[@"first_name"];
        _lastName = dictionary[@"last_name"];
        _profileImageUrl = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        _favoriteRoutes = [Route routeWithArray:dictionary[@"favorites"]];
        _outings = [NSMutableArray arrayWithArray:dictionary[@"outings"]];
        _ownRoutes = dictionary[@"routes"];
    }
    return self;
}

static User *_currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if(_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserPresentNotification object:nil userInfo:@{@"user": _currentUser}];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserMissingNotification object:nil];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)forget {
    _currentUser = nil;

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserMissingNotification object:nil userInfo:@{@"forget": @(true)}];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
