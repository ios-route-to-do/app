//
//  UIImageView+ProgressIndicator.m
//  Jopp
//
//  Created by Juan Pablo Marzetti on 12/9/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "UIImageView+ProgressIndicator.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (ProgressIndicator)

- (void)setImageWithProgressIndicatorAndURL:(NSURL *)url completion:(void (^)(NSError *error))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __weak UIImageView *weakSelf = self; // Always use weak in Blocks
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)]; // Remove previous that not stop
    
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator.frame = self.bounds;
    [self addSubview:activityIndicator];
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    
    void (^removeSpinner)(void) = ^{ // Desctuctor Block
        if (activityIndicator) {
            [activityIndicator setHidden:YES];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
    };
    
    [self setImageWithURLRequest:request placeholderImage:nil success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        removeSpinner();
        weakSelf.image = image;
        if (completion) {
            completion(nil);
        }
    } failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        removeSpinner();
        if (completion) {
            completion(error);
        }
    }];
}    

@end
