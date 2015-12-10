//
//  CategoriesViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/8/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoryCollectionViewCell.h"
#import "HomeProfileViewController.h"
#import "BackendRepository.h"
#import "AppDelegate.h"
#import "Utils.h"

@interface CategoriesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;

@property (nonatomic) NSArray<RouteCategory *> *categories;

@property (weak, nonatomic) IBOutlet UIView *loginAnimationView;
@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLogoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLogoWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLogoHeightConstraint;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *categoryCell = [UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil];
    [self.categoriesCollectionView registerNib:categoryCell forCellWithReuseIdentifier:@"categoryCollectionViewCell"];

    self.categoriesCollectionView.delegate = self;
    self.categoriesCollectionView.dataSource = self;
    self.loginAnimationView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(kDarkPurpleColorHex);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationItem.title = @"Jopp";


    id<BackendRepository> repo = [BackendRepository sharedInstance];
    [repo allCategoriesWithCompletion:^(NSArray *categories, NSError *error) {
        self.categories = categories;
        [self.categoriesCollectionView reloadData];
    }];
    
    self.loginAnimationView.hidden = !self.animateLogin;
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.animateLogin) {
        [UIView animateWithDuration:0.2 animations:^{
            self.loginLogoTopConstraint.constant = 24;
            self.loginLogoWidthConstraint.constant = 59;
            self.loginLogoHeightConstraint.constant = 28;
            self.loginImageView.alpha = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.loginAnimationView.hidden = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionWidth = self.categoriesCollectionView.bounds.size.width;
    float cellWidth = collectionWidth / 2.0 - 8; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth);

    return size;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCollectionViewCell *cell = [self.categoriesCollectionView dequeueReusableCellWithReuseIdentifier:@"categoryCollectionViewCell" forIndexPath:indexPath];
    cell.category = self.categories[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeProfileViewController *homeController = [[HomeProfileViewController alloc] initDefault];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeController];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate changeRootViewController:nav];
}

@end
