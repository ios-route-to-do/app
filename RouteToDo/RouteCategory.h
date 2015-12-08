//
//  Category.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/19/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Route;

@interface RouteCategory : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSArray<Route *> *routes;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)routeCategoryWithArray:(NSArray *) array;

@end
