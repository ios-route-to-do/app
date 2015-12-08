//
//  RouteStepViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import <MapKit/MapKit.h>

#import "RouteStepViewController.h"
#import "PlaceAnnotation.h"
#import "ArcPathRenderer.h"
#import "Place.h"
#import "RouteRatingView.h"
#import "CNPPopupController.h"
#import "BackendRepository.h"
#import "Utils.h"

@interface RouteStepViewController () <MKMapViewDelegate, CLLocationManagerDelegate, CNPPopupControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet MKMapView *routeMapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic) id<MKAnnotation> initialPoint;
@property (nonatomic) id<MKAnnotation> destinationPoint;

@property (nonatomic) NSArray *annotations;
@property (strong, nonatomic) ArcPathRenderer *routeLineRenderer;

@property (nonatomic) RouteStepViewController *nextStepController;
@property (nonatomic) CNPPopupController *ratingPopupController;
@property (nonatomic) UIBarButtonItem *likeButton;

@property (nonatomic) BOOL isFirstStep;
@property (nonatomic) BOOL isLastStep;
@property (atomic) BOOL needsMapRefresh;

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation RouteStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    #endif

    self.routeMapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    self.nextStepController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    //Solid
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(kDarkPurpleColorHex);
    
    //Right Buttons
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:0 target:self action:@selector(onShareButtonTap)];

    [self updateLikeButton:self.route.favorite animated:NO];
    [self.navigationItem setRightBarButtonItems:@[btnShare, self.likeButton]];
    
    self.nextStepButton.layer.cornerRadius = self.nextStepButton.frame.size.height / 2;
    self.nextStepButton.layer.masksToBounds = YES;
    
    if (self.route != nil) {
        [self loadDataFromRoute:self.route andStep:[self.step integerValue]];
    }
    
    self.needsMapRefresh = YES;
    [self loadMapData];
}

- (void)viewDidAppear:(BOOL)animated {
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.initialPoint == nil) {
        self.initialPoint = userLocation;
        self.needsMapRefresh = YES;
        [self.locationManager stopUpdatingLocation];
    }
    
    [self loadMapData];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
        PlaceAnnotation *placeAnnotation = (PlaceAnnotation *)annotation;
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PlaceAnnotation"];
        
        if (view == nil) {
            view = [[MKAnnotationView alloc] initWithAnnotation:placeAnnotation reuseIdentifier:@"PlaceAnnotation"];
            view.enabled = YES;
            view.canShowCallout = YES;
        } else {
            view.annotation = annotation;
        }

        view.image = [placeAnnotation pinImage];
        return view;
    } else {
        return nil;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if (self.routeLineRenderer == nil) {
        self.routeLineRenderer = [[ArcPathRenderer alloc] initWithPolyline:overlay];
        self.routeLineRenderer.strokeColor = UIColorFromRGB(kLightBlueColorHex);
        self.routeLineRenderer.lineWidth = 2;
        self.routeLineRenderer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
                                                  [NSNumber numberWithInt:10],nil];
    }
    
    return self.routeLineRenderer;
}

- (void) onShareButtonTap {
    [NSException raise:@"Not implemented" format:@"TODO"];
}

- (void) onLikeButtonTap {
    id<BackendRepository> repository = [BackendRepository sharedInstance];
    [repository toggleRouteFavoriteWithUser:nil route:self.route completion:^(NSError *error) {
        if (error) {
            return;
        }

        [self updateLikeButton:self.route.favorite animated:YES];
    }];
}

- (IBAction)onNextStepButtonTap:(id)sender {
    if (!self.isLastStep) {
        if (!self.nextStepController) {
            self.nextStepController = [[RouteStepViewController alloc] init];
            self.nextStepController.route = self.route;
            self.nextStepController.step = @([self.step integerValue] + 1);
        }
        
        [self.navigationController pushViewController:self.nextStepController animated:YES];
    } else {
        RouteRatingView *ratingView = [[RouteRatingView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        ratingView.route = self.route;

        self.ratingPopupController = [[CNPPopupController alloc] initWithContents:@[ratingView]];
        self.ratingPopupController.theme = [CNPPopupTheme defaultTheme];
        self.ratingPopupController.theme.popupStyle = CNPPopupStyleCentered;
        self.ratingPopupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
        self.ratingPopupController.theme.cornerRadius = 20.0f;
        self.ratingPopupController.theme.popupContentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        self.ratingPopupController.theme.contentVerticalPadding = 0.0f;
        self.ratingPopupController.delegate = self;
        [self.ratingPopupController presentPopupControllerAnimated:YES];
    }
}

- (void) loadDataFromRoute:(Route *)route andStep:(long)step {
    self.isFirstStep = (step == 0);
    self.isLastStep = (step == (route.places.count - 1));
    Place *place = route.places[step];
    
    [self.imageImageView setImageWithURL:place.imageUrl];
    self.nameLabel.text = place.name;
    self.addressLabel.text = place.address;
    self.descriptionLabel.text = place.fullDescription;
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];

    MKUserLocation *userLocation = self.routeMapView.userLocation;

    if (!self.isFirstStep) {
        Place *previousPlace = route.places[step - 1];
        self.initialPoint = [[PlaceAnnotation alloc] initWithPlace:previousPlace step:(step - 1)];
        [annotations addObject:self.initialPoint];
    }

    [annotations addObject:userLocation];

    self.destinationPoint = [[PlaceAnnotation alloc] initWithPlace:place step:step];
    [annotations addObject:self.destinationPoint];
    
    [self.routeMapView addAnnotations:annotations];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.destinationPoint coordinate] , 1000, 1000);
    [self.routeMapView setRegion:region animated:NO];
    
    if (self.isLastStep) {
        [self.nextStepButton setTitle:@"Rate this Route" forState:UIControlStateNormal];
    } else {
        [self.nextStepButton setTitle:@"Next Place" forState:UIControlStateNormal];
    }
    
    self.annotations = annotations;
}

- (void) loadMapData {
    CLLocationCoordinate2D point1 = [self.initialPoint coordinate];
    CLLocationCoordinate2D point2 = [self.destinationPoint coordinate];
    
    if (self.needsMapRefresh) {
        MKCoordinateRegion region;

        if (self.initialPoint == nil) {
            region.center.latitude = point2.latitude;
            region.center.longitude = point2.longitude;
            
            // Add a little extra space on the sides
            region.span.latitudeDelta = 0.01;
            region.span.longitudeDelta = 0.01;
        } else {
            region.center.latitude = (point1.latitude + point2.latitude) / 2.0;
            region.center.longitude = (point1.longitude + point2.longitude) / 2.0;
            
            // Add a little extra space on the sides
            region.span.latitudeDelta = fabs(point1.latitude - point2.latitude) * 1.6;
            region.span.longitudeDelta = fabs(point1.longitude - point2.longitude) * 1.6;
        }

        region = [self.routeMapView regionThatFits:region];
        [self.routeMapView setRegion:region animated:NO];
        
        [self.routeMapView removeOverlays:self.routeMapView.overlays];
        self.needsMapRefresh = NO;
    }

    if (self.routeMapView.overlays.count == 0 && self.initialPoint) {
        CLLocationCoordinate2D coordinateArray[2];
        coordinateArray[0]= point1;
        coordinateArray[1]= point2;
        
        MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
        [self.routeMapView addOverlay:routeLine];
        [self.routeMapView setNeedsDisplay];
    }
}

- (void) updateLikeButton:(BOOL)favorite animated:(BOOL)animated {
    UIImage *likeImage = [[UIImage imageNamed:(favorite ? @"fav_active" : @"fav_inactive")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if (self.likeButton == nil) {
        UIImageView *image = [[UIImageView alloc] initWithImage:likeImage];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = image.bounds;
        [button addSubview:image];
        [button addTarget:self action:@selector(onLikeButtonTap) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        UIImageView *image = [self.likeButton.customView.subviews firstObject];
        image.image = likeImage;
    }
    
    if (animated) {
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulseAnimation.duration = 0.15;
        pulseAnimation.toValue = [NSNumber numberWithFloat:1.5];;
        pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulseAnimation.autoreverses = YES;
        pulseAnimation.repeatCount = 1;
        
        [self.likeButton.customView.layer addAnimation:pulseAnimation forKey:@"scaleAnimation"];
    }
}


@end
