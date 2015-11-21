//
//  Category.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface RouteCategory : PFObject<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *imageUrl;
@property (nonatomic) NSArray *routes;

@end
