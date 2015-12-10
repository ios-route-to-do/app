//
//  ProfileViewController.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "ProfileViewController.h"
#include "Utils.h"
#import "BackendRepository.h"
#import "User.h"
#import "LargeRouteCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "RouteCoverViewController.h"

#import "mocks.h"

@interface ProfileViewController () <UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UITabBar *userProfileTabBar;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileBackgroundRouteImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *userProfileRoutesCollectionView;
@property (weak, nonatomic) IBOutlet UIView *userProfileImageSupportView;

@property (nonatomic) NSArray<CustomTabControllerItem *> *controllerItems;
@property (nonatomic) UIViewController *currentController;

@property (nonatomic, strong) NSArray *userFavoritesRoutesViewArray;
@property (nonatomic, strong) NSArray *userNightsOutRoutesViewArray;
@property (nonatomic, strong) NSArray *userMyRoutesViewArray;

@end

@implementation ProfileViewController

- (instancetype) initWithItems:(NSArray<CustomTabControllerItem *> *)items {
    if (self = [super init]) {
        _controllerItems = items;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userProfileTabBar.delegate = self;
    self.userProfileTabBar.tintColor =[UIColor clearColor];

    //todo: do this when initializing the controller
    NSLog(@" profile view did load ");
    self.user = [User currentUser];
    
    [self.userProfileImageView setImageWithURL:self.user.profileImageUrl];

    self.userProfileImageSupportView.layer.cornerRadius = self.userProfileImageSupportView.frame.size.height / 2;
    self.userProfileImageSupportView.layer.masksToBounds = YES;

    self.userProfileImageView.layer.cornerRadius = self.userProfileImageSupportView.frame.size.height / 2;
    self.userProfileImageView.layer.masksToBounds = YES;
    
    self.usernameLabel.text = self.user.username;
    NSString *userInfoString = [self.user.location stringByAppendingString:@" • Owns "];
    userInfoString = [userInfoString stringByAppendingString:[@(self.user.ownRoutes.count) stringValue]];
    userInfoString = [userInfoString stringByAppendingString:@" Routes • "];
    userInfoString = [userInfoString stringByAppendingString:[@(self.user.outings.count) stringValue]];
    userInfoString = [userInfoString stringByAppendingString:@" Nights Out"];
    self.userInfoLabel.text = userInfoString;
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateSelected];
    
    UIImage *profileImage = [[UIImage imageNamed:@"fav_inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedProfileImage = [[UIImage imageNamed:@"fav_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:profileImage selectedImage:selectedProfileImage];
    [tabBarItems addObject:tabBarItem1];
    
    UIImage *nightsOutImage = [[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Nights Out" image:nightsOutImage selectedImage:nil];
    [tabBarItems addObject:tabBarItem2];
    
    UIImage *myRoutesImage = [[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"My Routes" image:myRoutesImage selectedImage:nil];
    [tabBarItems addObject:tabBarItem3];
    
    self.userProfileTabBar.items = tabBarItems;
    [self.userProfileTabBar setSelectedItem:[self.userProfileTabBar.items objectAtIndex:0]];
    
    UINib *largeCellNib = [UINib nibWithNibName:@"LargeRouteCollectionViewCell" bundle:nil];
    [self.userProfileRoutesCollectionView registerNib:largeCellNib forCellWithReuseIdentifier:@"largeRouteCollectionViewCell"];
    
    UICollectionViewFlowLayout *topFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [topFlowLayout setItemSize:CGSizeMake(240, 190)];
    [topFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [topFlowLayout setSectionInset:UIEdgeInsetsMake(0, 8, 0, 0)];
    [self.userProfileRoutesCollectionView setCollectionViewLayout:topFlowLayout];
    
    self.userProfileRoutesCollectionView.delegate = self;
    self.userProfileRoutesCollectionView.dataSource = self;
    
    [self loadRoutesWithCompletionHandler:^{
        NSLog(@"loaded initial tweets");
    }];
    

    
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"tab bar item title: %@", item.title);
//    CustomTabControllerItem *customItem = self.controllerItems[[tabBar.items indexOfObject:item]];
//    [self presentController:customItem.controller];
    [self.userProfileRoutesCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([self.userProfileTabBar.selectedItem.title isEqual:@"Favorites"]) {
        return self.userFavoritesRoutesViewArray.count;
    } else if ([self.userProfileTabBar.selectedItem.title isEqual:@"Nights Out"]) {
        return self.userNightsOutRoutesViewArray.count;
    } else if ([self.userProfileTabBar.selectedItem.title isEqual:@"My Routes"]) {
        return self.userMyRoutesViewArray.count;
    } else {
        //shouldn't get here
        return self.userFavoritesRoutesViewArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LargeRouteCollectionViewCell *largeCell = [[LargeRouteCollectionViewCell alloc] init];
    largeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largeRouteCollectionViewCell" forIndexPath:indexPath];
    largeCell.layer.cornerRadius = 5;
    largeCell.layer.borderWidth = 1;
    largeCell.layer.borderColor = [[UIColor whiteColor] CGColor];

    if ([self.userProfileTabBar.selectedItem.title isEqual:@"Favorites"]) {
        largeCell.route = (Route *)self.userFavoritesRoutesViewArray[indexPath.row];
    } else if ([self.userProfileTabBar.selectedItem.title isEqual:@"Nights Out"]) {
        largeCell.route = (Route *)self.userNightsOutRoutesViewArray[indexPath.row];
    } else if ([self.userProfileTabBar.selectedItem.title isEqual:@"My Routes"]) {
        largeCell.route = (Route *)self.userMyRoutesViewArray[indexPath.row];
    } else {
        //shouldn't get here
        largeCell.route = (Route *)self.userFavoritesRoutesViewArray[indexPath.row];
    }
    
    return largeCell;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    LargeRouteCollectionViewCell *largeCell = (LargeRouteCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    RouteCoverViewController *vc = [[RouteCoverViewController alloc] init];
    vc.route = largeCell.route;
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)loadRoutesWithCompletionHandler:(void (^)(void))completionHandler {
    
    id<BackendRepository> repository = [BackendRepository sharedInstance];
    
    [repository favoriteRoutesWithUser:self.user completion:^(NSArray *routes, NSError *error) {
        self.userFavoritesRoutesViewArray = routes;
        [self.userProfileRoutesCollectionView reloadData];
    }];
    
    [repository userOutingsWithUser:self.user completion:^(NSArray *routes, NSError *error) {
        self.userNightsOutRoutesViewArray = routes;
        [self.userProfileRoutesCollectionView reloadData];
    }];

    [repository userRoutesWithUser:self.user completion:^(NSArray *routes, NSError *error) {
        self.userMyRoutesViewArray = routes;
        [self.userProfileRoutesCollectionView reloadData];        
    }];
    
    [self.userProfileBackgroundRouteImageView setImageWithURL:[NSURL URLWithString:@"http://33.media.tumblr.com/b6ed58627630bb8652ab6c3068be565b/tumblr_inline_n91a7hHpIp1qb3qcf.jpg"]];
    
    self.userProfileBackgroundRouteImageView.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.userProfileBackgroundRouteImageView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.userProfileBackgroundRouteImageView addSubview:blurEffectView];
    
    [self.userProfileRoutesCollectionView reloadData];
    completionHandler();
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
