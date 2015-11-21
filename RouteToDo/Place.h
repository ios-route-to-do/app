//
//  Place.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Place : PFObject<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *fullDescription;
@property (nonatomic) NSString *geoLocation;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *address;
@property (nonatomic) NSURL *imageUrl;

@end
