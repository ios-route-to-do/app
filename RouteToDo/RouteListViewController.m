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

@interface RouteListViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *bottomCollectionView;

@property (nonatomic, strong) NSMutableArray *trendingRoutesViewArray;
@property (nonatomic, strong) NSMutableArray *recentRoutesViewArray;

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
        return largeCell;
    } else if (collectionView == self.bottomCollectionView){
         SmallRouteCollectionViewCell *smallCell = [[SmallRouteCollectionViewCell alloc] init];
        smallCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallRouteCollectionViewCell" forIndexPath:indexPath];
//        cell.route = (Route *)self.recentRoutesViewArray[indexPath.row];
        return smallCell;
    }
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.topCollectionView){
        [self.topCollectionView deselectItemAtIndexPath:indexPath animated:YES];
        NSLog(@"did select top collection");
        //    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
        //    vc.tweet = self.tweets[indexPath.row];
        //    [self.navigationController pushViewController:vc animated:YES];
    } else if (collectionView == self.bottomCollectionView){
        [self.bottomCollectionView deselectItemAtIndexPath:indexPath animated:YES];
        NSLog(@"did select bottom collection");
        //    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
        //    vc.tweet = self.tweets[indexPath.row];
        //    [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)loadRoutesWithCompletionHandler:(void (^)(void))completionHandler {
    
    self.trendingRoutesViewArray = [NSMutableArray array];
    self.recentRoutesViewArray = [NSMutableArray array];
    Route *templateRoute = [[Route alloc] init];
    templateRoute.title = @"The beer Route !";
    templateRoute.location = @"San Francisco";
    templateRoute.author = @"Matigol";
    templateRoute.usersCount = [NSNumber numberWithInt:300];
//    templateRoute.imageUrl = [NSURL URLWithString:@"https://test.com"];
  
    for(int i = 0; i < 10; i++)
    {
        [self.trendingRoutesViewArray addObject:templateRoute];
    }
    
    Route *templateSmallRoute = [[Route alloc] init];
    templateSmallRoute.title = @"All night long !";
    templateSmallRoute.location = @"Oakland";
    templateSmallRoute.author = @"party_boy";
    templateSmallRoute.usersCount = [NSNumber numberWithInt:450];
//    templateSmallRoute.imageUrl = [NSURL URLWithString:@"https://test.com"];
    
    for(int i = 0; i < 12; i++)
    {
        [self.recentRoutesViewArray addObject:templateSmallRoute];
    }
    
//    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
//            self.tweets = tweets;
//            [self.tableView reloadData];
//            completionHandler();
//        }];
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
