//
//  LargeRouteCollectionViewCell.h
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@class LargeRouteCollectionViewCell;

@protocol LargeRouteCollectionViewCellDelegate <NSObject>

- (void)didTapRouteCell:(LargeRouteCollectionViewCell *)cell;

@end

@interface LargeRouteCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Route *route;
@property (nonatomic, weak) id <LargeRouteCollectionViewCellDelegate> delegate;

@end
