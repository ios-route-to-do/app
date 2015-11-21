//
//  RouteStepViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteStepViewController.h"
#import <MapKit/MapKit.h>
#import "PlaceAnnotation.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface RouteStepViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet MKMapView *routeMapView;
@property (strong, nonatomic) PlaceAnnotation *placeAnnotation;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView *routeLineView;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation RouteStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
    }
    #endif

    self.routeMapView.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    //Solid
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x673AB7);
    
    //Right Buttons
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:0 target:self action:@selector(onShareButtonTap)];

    UIImage *likeImage = [[UIImage imageNamed:@"fav_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *btnLike = [[UIBarButtonItem alloc] initWithImage:likeImage style:0 target:self action:@selector(onLikeButtonTap)];
    [self.navigationItem setRightBarButtonItems:@[btnShare, btnLike]];
    
    self.nextStepButton.layer.cornerRadius = self.nextStepButton.frame.size.height / 2;
    self.nextStepButton.layer.masksToBounds = YES;
    
    CLLocationCoordinate2D eddies = CLLocationCoordinate2DMake(37.32320, -122.05159);
    self.placeAnnotation = [[PlaceAnnotation alloc] initWithTitle:@"Paul & Eddie's" andLocation:eddies];
    
    MKUserLocation *userLocation = self.routeMapView.userLocation;
    [self.routeMapView addAnnotations:@[userLocation, self.placeAnnotation]];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(eddies, 1000, 1000);
    [self.routeMapView setRegion:region animated:NO];

}

- (void)viewDidAppear:(BOOL)animated {
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D point1 = self.placeAnnotation.coordinate;
    CLLocationCoordinate2D point2 = userLocation.location.coordinate;
    
    MKCoordinateRegion region;
    region.center.latitude = (point1.latitude + point2.latitude) / 2.0;
    region.center.longitude = (point1.longitude + point2.longitude) / 2.0;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(point1.latitude - point2.latitude) * 1.6;
    region.span.longitudeDelta = fabs(point1.longitude - point2.longitude) * 1.6;
    region = [mapView regionThatFits:region];
    
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0]= point1;
    coordinateArray[1]= point2;
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    [mapView addOverlay:self.routeLine];
    
    [mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
        PlaceAnnotation *myPlace = (PlaceAnnotation *)annotation;
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PlaceAnnotation"];
        
        if (view == nil) {
            view = myPlace.annotationView;
        } else {
            view.annotation = annotation;
        }
        
        return view;
    } else {
        return nil;
    }
}
//
//-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
//{
//    if(overlay == self.routeLine)
//    {
//        if(nil == self.routeLineView)
//        {
//            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
//            self.routeLineView.fillColor = [UIColor redColor];
//            self.routeLineView.strokeColor = [UIColor redColor];
//            self.routeLineView.lineWidth = 5;
//            
//        }
//        
//        return self.routeLineView;
//    }
//    
//    return nil;
//}

- (void) onShareButtonTap {
    
}

- (void) onLikeButtonTap {
    
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
