//
//  Route.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Route : NSObject // PFObject<PFSubclassing>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *fullDescription;
@property (nonatomic) NSURL *imageUrl;
@property (nonatomic) NSArray *places;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *usersCount;
@property (nonatomic) NSArray *categories;
@property (nonatomic) BOOL favorite;

@end
