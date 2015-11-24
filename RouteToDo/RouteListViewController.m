//
//  RouteListViewController.m
//  RouteToDo
//
//  Created by Matias Arenas Sepulveda on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteListViewController.h"
#import "HomeProfileViewController.h"
#import "LargeRouteCollectionViewCell.h"
#import "SmallRouteCollectionViewCell.h"
#import "Route.h"
#import "UIImageView+AFNetworking.h"
#import "mocks.h"

@interface RouteListViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSArray *trendingRoutesViewArray;
@property (nonatomic, strong) NSArray *recentRoutesViewArray;

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
    
    // Do any additional setup after loading the view from its nib.
    //get data
    [self loadRoutesWithCompletionHandler:^{
        NSLog(@"loaded initial tweets");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        largeCell.route = (Route *)self.trendingRoutesViewArray[indexPath.row];
        largeCell.layer.cornerRadius = 5;
        largeCell.layer.borderWidth = 1;
        largeCell.layer.borderColor = [[UIColor whiteColor] CGColor];
        return largeCell;
    } else if (collectionView == self.bottomCollectionView){
         SmallRouteCollectionViewCell *smallCell = [[SmallRouteCollectionViewCell alloc] init];
        smallCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallRouteCollectionViewCell" forIndexPath:indexPath];
        smallCell.route = (Route *)self.recentRoutesViewArray[indexPath.row];
        smallCell.layer.cornerRadius = 5;
        smallCell.layer.borderWidth = 1;
        smallCell.layer.borderColor = [[UIColor whiteColor] CGColor];
        return smallCell;
    }
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.topCollectionView){
        [self.topCollectionView deselectItemAtIndexPath:indexPath animated:YES];
        NSLog(@"did select top collection");
        //TODO: Load corresponding view controller
        //    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
        //    vc.tweet = self.tweets[indexPath.row];
        //    [self.navigationController pushViewController:vc animated:YES];
    } else if (collectionView == self.bottomCollectionView){
        [self.bottomCollectionView deselectItemAtIndexPath:indexPath animated:YES];
        NSLog(@"did select bottom collection");
        //TODO: Load corresponding view controller        
        //    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
        //    vc.tweet = self.tweets[indexPath.row];
        //    [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadRoutesWithCompletionHandler:(void (^)(void))completionHandler {

    //TODO: get routes from Parser Client
    //    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
    //            self.tweets = tweets;
    //            [self.tableView reloadData];
    //            completionHandler();
    //        }];
    
    self.trendingRoutesViewArray = mockRouteWithouthPlaces1Array();
    self.recentRoutesViewArray = mockRouteWithouthPlaces2Array();
    
    
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:@"http://33.media.tumblr.com/b6ed58627630bb8652ab6c3068be565b/tumblr_inline_n91a7hHpIp1qb3qcf.jpg"]];
    
//    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:@"https://backoftheferry.files.wordpress.com/2014/10/sf-pi-bar.jpg"]];
    
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.backgroundImageView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.backgroundImageView addSubview:blurEffectView];
    
    [self.topCollectionView reloadData];
    [self.bottomCollectionView reloadData];
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
