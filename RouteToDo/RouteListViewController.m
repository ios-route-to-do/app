//
//  RouteListViewController.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteListViewController.h"
#import "LargeRouteCollectionViewCell.h"
#import "SmallRouteCollectionViewCell.h"
#import "RouteCoverViewController.h"
#import "UIImageView+AFNetworking.h"

#import "RouteRatingView.h"
#import "CNPPopupController.h"

#import "Utils.h"
#import "BackendRepository.h"


@interface RouteListViewController () <RouteRatingControlDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSArray<Route *> *trendingRoutesViewArray;
@property (nonatomic, strong) NSArray<Route *> *recentRoutesViewArray;

@property (nonatomic) CNPPopupController *ratingPopupController;

@end

@implementation RouteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *largeCellNib = [UINib nibWithNibName:@"LargeRouteCollectionViewCell" bundle:nil];
    [self.topCollectionView registerNib:largeCellNib forCellWithReuseIdentifier:@"largeRouteCollectionViewCell"];

    UINib *smallCellNib = [UINib nibWithNibName:@"SmallRouteCollectionViewCell" bundle:nil];
    [self.bottomCollectionView registerNib:smallCellNib forCellWithReuseIdentifier:@"smallRouteCollectionViewCell"];

    UICollectionViewFlowLayout *topFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [topFlowLayout setItemSize:CGSizeMake(240, 190)];
    [topFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [topFlowLayout setSectionInset:UIEdgeInsetsMake(0, 8, 0, 0)];
    [self.topCollectionView setCollectionViewLayout:topFlowLayout];

    UICollectionViewFlowLayout *bottomFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [bottomFlowLayout setItemSize:CGSizeMake(148, 100)];
    [bottomFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [bottomFlowLayout setMinimumInteritemSpacing:8];
    [bottomFlowLayout setMinimumLineSpacing:8];

    [self.bottomCollectionView setCollectionViewLayout:bottomFlowLayout];

    self.topCollectionView.delegate = self;
    self.bottomCollectionView.delegate = self;
    self.topCollectionView.dataSource = self;
    self.bottomCollectionView.dataSource = self;

    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:@"http://33.media.tumblr.com/b6ed58627630bb8652ab6c3068be565b/tumblr_inline_n91a7hHpIp1qb3qcf.jpg"]];
    self.backgroundImageView.backgroundColor = [UIColor clearColor];

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.backgroundImageView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.backgroundImageView addSubview:blurEffectView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteFinishedNotification:) name:RouteFinishedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    //Solid
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(kDarkPurpleColorHex);

    //Right Buttons
    UIImage *searchImage = [[UIImage imageNamed:@"search"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:0 target:self action:@selector(onSearchButtonTap)];
    UIImage *mapImage = [[UIImage imageNamed:@"location"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:mapImage style:0 target:self action:@selector(onMapButtonTap)];

    [self.parentViewController.navigationItem setRightBarButtonItems:@[searchButton]];
    [self.topCollectionView reloadData];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.topCollectionView){
        return self.trendingRoutesViewArray.count;
    } else if (collectionView == self.bottomCollectionView){
        return self.recentRoutesViewArray.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.topCollectionView){
        LargeRouteCollectionViewCell *largeCell = [[LargeRouteCollectionViewCell alloc] init];
        largeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largeRouteCollectionViewCell" forIndexPath:indexPath];
        largeCell.route = self.trendingRoutesViewArray[indexPath.row];
        largeCell.layer.cornerRadius = 5;
        largeCell.layer.borderWidth = 1;
        largeCell.layer.borderColor = [[UIColor whiteColor] CGColor];
        return largeCell;
    } else if (collectionView == self.bottomCollectionView){
        SmallRouteCollectionViewCell *smallCell = [[SmallRouteCollectionViewCell alloc] init];
        smallCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallRouteCollectionViewCell" forIndexPath:indexPath];
        smallCell.route = self.recentRoutesViewArray[indexPath.row];
        smallCell.layer.cornerRadius = 5;
        smallCell.layer.borderWidth = 1;
        smallCell.layer.borderColor = [[UIColor whiteColor] CGColor];
        return smallCell;
    }
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    if (collectionView == self.topCollectionView){
        LargeRouteCollectionViewCell *largeCell = (LargeRouteCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

        RouteCoverViewController *vc = [[RouteCoverViewController alloc] init];
        vc.route = largeCell.route;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (collectionView == self.bottomCollectionView){
        SmallRouteCollectionViewCell *smallCell = (SmallRouteCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

        RouteCoverViewController *vc = [[RouteCoverViewController alloc] init];
        vc.route = smallCell.route;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)routeRatingView:(RouteRatingView *)view didTapCancelWithRating:(long)rating {
    [self.ratingPopupController dismissPopupControllerAnimated:YES];
    self.ratingPopupController = nil;
}

- (void)routeRatingView:(RouteRatingView *)view didTapSubmitWithRating:(long)rating {
    id<BackendRepository> repository = [BackendRepository sharedInstance];
    [repository rateRouteWithUser:[User currentUser] route:view.route rating:rating completion:^(NSError *error) {
        NSLog(@"rated route");
        [self reloadAllRoutes];
    }];

    [self routeRatingView:view didTapCancelWithRating:rating];
}

- (void) onSearchButtonTap {
    NSLog(@"search button tapped");
}

- (void) onMapButtonTap {
    NSLog(@"map button tapped");
}

- (void)onRouteFinishedNotification:(NSNotification *)notification {
    Route *route = notification.userInfo[@"route"];

    RouteRatingView *ratingView = [[RouteRatingView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    ratingView.route = route;
    ratingView.delegate = self;

    self.ratingPopupController = [[CNPPopupController alloc] initWithContents:@[ratingView]];
    self.ratingPopupController.theme = [CNPPopupTheme defaultTheme];
    self.ratingPopupController.theme.popupStyle = CNPPopupStyleCentered;
    self.ratingPopupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    self.ratingPopupController.theme.cornerRadius = 20.0f;
    self.ratingPopupController.theme.popupContentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.ratingPopupController.theme.shouldDismissOnBackgroundTouch = NO;
    self.ratingPopupController.theme.contentVerticalPadding = 0.0f;
    [self.ratingPopupController presentPopupControllerAnimated:YES];
}

- (void)reloadAllRoutes {
    id<BackendRepository> repository = [BackendRepository sharedInstance];

    [repository trendingRoutesWithLocation:nil completion:^(NSArray *routes, NSError *error) {
        self.trendingRoutesViewArray = routes;
        [self.topCollectionView reloadData];
    }];

    [repository newRoutesWithLocation:nil completion:^(NSArray *routes, NSError *error) {
        self.recentRoutesViewArray = routes;
        [self.bottomCollectionView reloadData];
    }];
}

@end
