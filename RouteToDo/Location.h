//
//  Location.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Location : PFObject<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *coordinates;
@property (nonatomic) NSString *radius;

+ (NSString *)parseClassName;

@end
