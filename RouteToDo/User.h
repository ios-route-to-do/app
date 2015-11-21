//
//  User.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : PFObject<PFSubclassing>

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSURL *profileImageUrl;
@property (nonatomic) NSArray *favoriteRoutes;
@property (nonatomic) NSArray *outings;
@property (nonatomic) NSArray *ownRoutes;

@end
