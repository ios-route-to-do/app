//
//  User.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.favoriteRoutes = [NSMutableArray array];
        self.outings = [NSMutableArray array];
        self.ownRoutes = [NSMutableArray array];
    }
    return self;
}

@end
