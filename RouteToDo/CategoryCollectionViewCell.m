//
//  CategoryCollectionViewCell.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/8/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "CategoryCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CategoryCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;

@end

@implementation CategoryCollectionViewCell

- (void)awakeFromNib {
    self.categoryImage.layer.cornerRadius = 5;
    self.categoryImage.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)setCategory:(RouteCategory *)category {
    self.categoryTitleLabel.text = category.name;
    [self.categoryImage setImageWithURL:category.imageUrl];
}

@end
