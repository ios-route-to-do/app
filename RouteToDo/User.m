//
//  User.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic username;
@dynamic location;
@dynamic firstName;
@dynamic lastName;
@dynamic profileImageUrl;
@dynamic favoriteRoutes;
@dynamic outings;
@dynamic ownRoutes;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"User";
}

@end
