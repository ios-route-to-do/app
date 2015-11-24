//
//  CustomTabControllerItem.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/24/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomTabControllerItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIViewController* controller;

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image andController:(UIViewController *)controller;

@end
