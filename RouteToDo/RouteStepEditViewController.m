//
//  RouteStepEditViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import <MapKit/MapKit.h>

#import "RouteStepEditViewController.h"
#import "PlaceAnnotation.h"
#import "ArcPathRenderer.h"
#import "Place.h"
#import "RouteRatingView.h"
#import "CNPPopupController.h"
#import "BackendRepository.h"
#import "Utils.h"
#import "CustomViewWithKeyboardAccessory.h"
#import "PlaceEditView.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface RouteStepEditViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, PlaceEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet MKMapView *routeMapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic) NSArray *annotations;
@property (nonatomic) Place *place;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;

@property (nonatomic) RouteStepEditViewController *nextStepController;

@property (nonatomic) BOOL emptyLocation;
@property (nonatomic) BOOL inSearchMode;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UIBarButtonItem *searchButton;

@property (nonatomic) UIVisualEffectView *blurEffectView;

@property (nonatomic) BOOL canProceed;

@end

@implementation RouteStepEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePlaceEditView)];
    [self.view addGestureRecognizer:recognizer];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];

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
    self.searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:0 target:self action:@selector(onSearchButtonTap)];

    [self.navigationItem setRightBarButtonItems:@[self.searchButton]];
    
    self.nextStepButton.layer.cornerRadius = self.nextStepButton.frame.size.height / 2;
    self.nextStepButton.layer.masksToBounds = YES;
    
    Place *place = self.route.places[self.step];
    [self resetViewToPlace:place];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.emptyLocation) {
        if (self.step == 0) {
            self.routeMapView.showsUserLocation = YES;
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.locationManager startUpdatingLocation];
        } else {
            CLLocationCoordinate2D coord = self.route.places[self.step - 1].coordinates;
            self.currentLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
            [self.routeMapView setRegion:MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 3000, 3000) animated:NO];
        }
    }
}

- (IBAction)onEditPlaceButtonTap:(id)sender {
    [self showPlaceEdit];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count == 0)
        return;

    self.currentLocation = [locations lastObject];
    [self.routeMapView setRegion:MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 3000, 3000) animated:YES];
    [self.locationManager stopUpdatingLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
        PlaceAnnotation *placeAnnotation = (PlaceAnnotation *)annotation;
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PlaceAnnotation"];
        
        if (view == nil) {
            view = [[MKAnnotationView alloc] initWithAnnotation:placeAnnotation reuseIdentifier:@"PlaceAnnotation"];
            view.enabled = YES;
            view.canShowCallout = NO;
        }

        view.image = [placeAnnotation pinImage];
        return view;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    PlaceAnnotation *annotation = (PlaceAnnotation *)view.annotation;
    annotation.selected = NO;
    view.image = [annotation pinImage];
    [view setNeedsDisplay];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    PlaceAnnotation *annotation = (PlaceAnnotation *)view.annotation;
    annotation.selected = YES;
    view.image = [annotation pinImage];
    [view setNeedsDisplay];
    [self loadDataFromPlace:annotation.place];
}

- (void) onSearchButtonTap {
    if (self.inSearchMode) {
        [self.searchBar endEditing:YES];
        self.navigationItem.titleView = nil;
        self.inSearchMode = NO;
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.navigationItem setRightBarButtonItem:self.searchButton animated:YES];
    } else {
        if (!self.searchBar) {
            self.searchBar = [[UISearchBar alloc] init];
            self.searchBar.showsCancelButton = YES;
            self.searchBar.delegate = self;
        }

        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        self.navigationItem.titleView = self.searchBar;
        self.inSearchMode = YES;
        [self.searchBar becomeFirstResponder];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self onSearchButtonTap];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    id<BackendRepository> repo = [BackendRepository sharedInstance];

    if (self.currentLocation) {
        [repo searchPlacesWithCoordinates:self.currentLocation.coordinate searchQuery:searchBar.text completion:^(MKCoordinateRegion region, NSArray<Place *> *places, NSError *error) {
            if (error) {

            } else {
                [self loadMapDataWithRegion:region places:places autoSelected:NO];
            }
        }];
    } else {
        [repo searchPlacesWithLocation:self.route.location searchQuery:searchBar.text completion:^(MKCoordinateRegion region, NSArray<Place *> *places, NSError *error) {
            if (error) {

            } else {
                [self loadMapDataWithRegion:region places:places autoSelected:NO];
            }
        }];
    }

    [self onSearchButtonTap];
}


- (void)placeEditView:(PlaceEditView *)view didCancelEditingPlace:(Place *)place {
    [self hidePlaceEditView];
}

- (void)placeEditView:(PlaceEditView *)view didSavePlace:(Place *)place {
    [self loadDataFromPlace:place];
    [self hidePlaceEditView];
}

- (IBAction)onNextStepButtonTap:(id)sender {
    if (self.step < (self.route.places.count - 1)) {
        if (!self.nextStepController) {
            self.nextStepController = [[RouteStepEditViewController alloc] init];
            self.nextStepController.route = self.route;
            self.nextStepController.step = self.step + 1;
        }

        if (self.route.places[self.step] != self.place) {
            NSMutableArray *places = [[NSMutableArray alloc] initWithArray:self.route.places];
            places[self.step] = self.place;
            self.route.places = places;
        }
        [self.navigationController pushViewController:self.nextStepController animated:YES];
    } else {
        NSMutableArray *places = [[NSMutableArray alloc] initWithArray:self.route.places];
        places[self.step] = self.place;
        self.route.places = places;

        id<BackendRepository> repo = [BackendRepository sharedInstance];

        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [SVProgressHUD showWithStatus:@"Creating Route"];
        [repo createRouteWithObject:[self.route newRouteObjectForBackend] completion:^(Route *route, NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (route && !error) {
                [SVProgressHUD showSuccessWithStatus:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Can not create your route"];
            }
        }];
    }
}

- (void) loadDataFromPlace:(Place *)place {
    [self.imageImageView setImageWithURL:place.imageUrl];
    self.nameLabel.text = place.name;
    self.addressLabel.text = place.address;
    self.descriptionLabel.text = place.fullDescription;
    self.place = place;
    self.canProceed = (place.imageUrl) &&
                      (place.name && place.name.length > 0) &&
                      (place.address && place.address.length > 0) &&
                      (place.fullDescription && place.fullDescription.length > 0) &&
                      (place.coordinates.latitude != 0 && place.coordinates.longitude != 0);
    self.nextStepButton.hidden = !self.canProceed;
}

- (void) loadMapDataWithRegion:(MKCoordinateRegion)region places:(NSArray *)places autoSelected:(BOOL)autoSelected {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];

    long step = 0;
    for (Place *place in places) {
        PlaceAnnotation *placeAnnotation = [[PlaceAnnotation alloc] initWithPlace:place step:(++step)];
        placeAnnotation.selected = autoSelected && (step == 1);
        [annotations addObject:placeAnnotation];
    }

    [self.routeMapView removeAnnotations:self.annotations];
    [self.routeMapView addAnnotations:annotations];
    [self.routeMapView setRegion:region animated:YES];

    self.annotations = annotations;
}

- (void)resetViewToPlace:(Place *)place {
    [self loadDataFromPlace:place];

    if (place.coordinates.latitude == 0 && place.coordinates.longitude == 0) {
        self.emptyLocation = YES;
    } else {
        self.emptyLocation = NO;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(place.coordinates, 1000, 1000);
        [self loadMapDataWithRegion:region places:@[place] autoSelected:YES];
    }
}

- (void) showPlaceEdit {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0, CGRectGetWidth(screen), 200);
    PlaceEditView *placeEditView = [[PlaceEditView alloc] initWithFrame:frame];
    placeEditView.place = self.place;
    placeEditView.delegate = self;
    CustomViewWithKeyboardAccessory *view = ((CustomViewWithKeyboardAccessory *)self.view);
    view.inputAccessoryView = placeEditView;

    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        if (!self.blurEffectView) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        }
        self.blurEffectView.frame = self.view.bounds;
        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self.view addSubview:self.blurEffectView];
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
    self.navigationController.navigationBarHidden = YES;


    [self.view becomeFirstResponder];
    [placeEditView.placeNameTextField becomeFirstResponder];
}

- (void) hidePlaceEditView {
    //Remove focus from text field
    [self.view endEditing:NO];

    //Remove focus from editing box
    [self.view endEditing:YES];

    if (self.blurEffectView) {
        [self.blurEffectView removeFromSuperview];
        self.navigationController.navigationBarHidden = NO;
    }
}

@end
