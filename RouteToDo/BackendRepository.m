//
//  BackendRepository.m
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/25/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "BackendRepository.h"
#import "HttpRepository.h"

@implementation BackendRepository

+ (id<BackendRepository>)sharedInstance {
    static HttpRepository *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[HttpRepository alloc] init];
        }
    });

    return instance;
}

@end