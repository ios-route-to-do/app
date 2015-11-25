//
//  MockRepository.h
//  RouteToDo
//
//  Created by Gabriel Gayan on 15/24/11.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackendRepository.h"

@interface MockRepository : NSObject <BackendRepository>

+ (id<BackendRepository>)sharedInstance;

@end
