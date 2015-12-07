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

@interface RouteStepEditViewController () <MKMapViewDelegate, UISearchBarDelegate, PlaceEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet MKMapView *routeMapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic) NSArray *annotations;
@property (nonatomic) Place *place;

@property (nonatomic) RouteStepEditViewController *nextStepController;

@property (nonatomic) BOOL inSearchMode;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UIBarButtonItem *searchButton;

@property (nonatomic) UIVisualEffectView *blurEffectView;

@end

@implementation RouteStepEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePlaceEditView)];
    [self.view addGestureRecognizer:recognizer];
    
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
    
    if (self.route != nil) {
        Place *place = self.route.places[[self.step longValue]];
        [self resetViewToPlace:place];
    }
}

- (void)viewDidAppear:(BOOL)animated {
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationManager startUpdatingLocation];
}

- (IBAction)onEditPlaceButtonTap:(id)sender {
    [self showPlaceEdit];
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

    [repo searchPlacesWithLocation:self.route.location searchQuery:searchBar.text completion:^(MKCoordinateRegion region, NSArray<Place *> *places, NSError *error) {
        if (error) {

        } else {
            [self loadMapDataWithRegion:region places:places autoSelected:NO];
        }
    }];
    
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
//    if (!self.isLastStep) {
//        if (!self.nextStepController) {
//            self.nextStepController = [[RouteStepEditViewController alloc] init];
//            self.nextStepController.route = self.route;
//            self.nextStepController.step = @([self.step integerValue] + 1);
//        }
//        
//        [self.navigationController pushViewController:self.nextStepController animated:YES];
//    } else {
//        RouteRatingView *ratingView = [[RouteRatingView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
//        ratingView.route = self.route;
//
//        self.ratingPopupController = [[CNPPopupController alloc] initWithContents:@[ratingView]];
//        self.ratingPopupController.theme = [CNPPopupTheme defaultTheme];
//        self.ratingPopupController.theme.popupStyle = CNPPopupStyleCentered;
//        self.ratingPopupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
//        self.ratingPopupController.theme.cornerRadius = 20.0f;
//        self.ratingPopupController.theme.popupContentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
//        self.ratingPopupController.theme.contentVerticalPadding = 0.0f;
//        self.ratingPopupController.delegate = self;
//        [self.ratingPopupController presentPopupControllerAnimated:YES];
//    }
}

- (void) loadDataFromPlace:(Place *)place {
    [self.imageImageView setImageWithURL:place.imageUrl];
    self.nameLabel.text = place.name;
    self.addressLabel.text = place.address;
    self.descriptionLabel.text = place.fullDescription;
    self.place = place;
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

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(place.coordinates, 1000, 1000);
    [self loadMapDataWithRegion:region places:@[place] autoSelected:YES];
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
