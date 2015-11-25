//
//  User.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

@interface User : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSURL *profileImageUrl;
@property (nonatomic) NSMutableArray *favoriteRoutes;
@property (nonatomic) NSMutableArray *outings;
@property (nonatomic) NSMutableArray *ownRoutes;

@end
