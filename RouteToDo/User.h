//
//  User.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSURL *profileImageUrl;
@property (nonatomic) NSMutableArray *favoriteRoutes;
@property (nonatomic) NSMutableArray *outings;
@property (nonatomic) NSMutableArray *ownRoutes;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
@end
