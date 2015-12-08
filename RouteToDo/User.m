//
//  User.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "User.h"

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.favoriteRoutes = [NSMutableArray array];
//        self.outings = [NSMutableArray array];
//        self.ownRoutes = [NSMutableArray array];
//    }
//    return self;
//}

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
        _favoriteRoutes = dictionary[@"favorites"];
        _outings = dictionary[@"outings"];
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
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
