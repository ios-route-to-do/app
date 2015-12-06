//
//  ProfileViewController.h
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabControllerItem.h"
#import "User.h"

@interface ProfileViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) User *user;

- (instancetype) initWithItems:(NSArray<CustomTabControllerItem *> *)items;

@end
