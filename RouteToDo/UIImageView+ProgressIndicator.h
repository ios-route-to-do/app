//
//  UIImageView+ProgressIndicator.h
//  Jopp
//
//  Created by Juan Pablo Marzetti on 12/9/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ProgressIndicator)

- (void)setImageWithProgressIndicatorAndURL:(NSURL *)url completion:(void (^)(NSError *error))completion;

@end
