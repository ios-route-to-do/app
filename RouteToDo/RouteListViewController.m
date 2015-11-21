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

@interface RouteListViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *bottomCollectionView;

@property (nonatomic, strong) NSArray *trendingRoutesViewArray;
@property (nonatomic, strong) NSArray *recentRoutesViewArray;

@end

@implementation RouteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.topCollectionView = [[UICollectionView alloc] init];
//    self.bottomCollectionView = [[UICollectionView alloc] init];
    
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
    
    self.trendingRoutesViewArray = [NSArray arrayWithObjects:@"String1",@"String2",@"String3",@"String4",@"String5",@"String6",@"String7",nil];
    self.recentRoutesViewArray = [NSArray arrayWithObjects:@"recent 1",@"recent 2",@"recent 3",@"recent 4",@"recent 5",@"recent 6",@"recent 7",@"recent 8",nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    if(collectionView == self.topCollectionView){
//        return self.trendingRoutesViewArray.count;
//    } else if (collectionView == self.bottomCollectionView){
//        return self.recentRoutesViewArray.count;
//    }
    
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
    
//    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    
//    NSString *cellData = [data objectAtIndex:indexPath.row];
    
//    static NSString *cellIdentifier = @"largeRouteCollectionViewCell";
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    
//    [titleLabel setText:cellData];
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    if(collectionView == self.topCollectionView){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"largeRouteCollectionViewCell" forIndexPath:indexPath];
    } else if (collectionView == self.bottomCollectionView){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallRouteCollectionViewCell" forIndexPath:indexPath];
    }
    
    return cell;

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
