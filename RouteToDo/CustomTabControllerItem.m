//
//  CustomTabControllerItem.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/24/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "CustomTabControllerItem.h"

@implementation CustomTabControllerItem

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image andController:(UIViewController *)controller {
    CustomTabControllerItem *item = [[CustomTabControllerItem alloc] init];
    item.title = title;
    item.image = image;
    item.controller = controller;
    
    return item;
}

@end
