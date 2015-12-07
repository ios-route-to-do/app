//
//  RouteCoverEditViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "RouteCoverEditViewController.h"
#import "RouteCoverEditView.h"
#import "UIImageView+AFNetworking.h"
#import "RouteStepEditViewController.h"
#import "Place.h"
#import "BackendRepository.h"
#import "CustomViewWithKeyboardAccessory.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface RouteCoverEditViewController () <RouteCoverEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *editPlacesButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesListLabel;

@property (nonatomic) UIVisualEffectView *blurEffectView;
@property (nonatomic) RouteStepEditViewController *editStepController;
@property (nonatomic) UIImage *imageToBeUploaded;
@property (nonatomic) BOOL routeHasChanged;
@property (nonatomic) BOOL canProceedToPlaces;

@end


@implementation RouteCoverEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideRouteCoverEdit)];
    [self.view addGestureRecognizer:recognizer];

    if (self.route != nil) {
        [self loadDataFromRoute:self.route];
        self.imageToBeUploaded = nil;
        self.routeHasChanged = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //Transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Right Buttons
    UIBarButtonItem *btnTakePic = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(onTakePicButtonTap)];
    UIBarButtonItem *btnChoosePic = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"pictures"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:0 target:self action:@selector(onPickImageButtonTap)];

    [self.navigationItem setRightBarButtonItems:@[btnTakePic, btnChoosePic]];

    self.editPlacesButton.layer.cornerRadius = self.editPlacesButton.frame.size.height / 2;
    self.editPlacesButton.layer.masksToBounds = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

# pragma mark events

- (IBAction)onEditRouteButtonTap:(id)sender {
    [self showRouteCoverEdit];
}

- (IBAction)onEditPlacesButtonTap:(UIButton *)sender {
    if (self.editStepController == nil) {
        self.editStepController = [[RouteStepEditViewController alloc] init];
        self.editStepController.route = self.route;
        self.editStepController.step = 0;
    }

    if (self.imageToBeUploaded) {
        id<BackendRepository> repo = [BackendRepository sharedInstance];

        [SVProgressHUD showWithStatus:@"Uploading image"];
        [repo storeImage:self.imageToBeUploaded completion:^(NSString *imageUrl, NSError *error) {
            if (imageUrl && !error) {
                self.route.imageUrl = [NSURL URLWithString:imageUrl];
                self.imageToBeUploaded = nil;
                [SVProgressHUD showSuccessWithStatus:nil];
                [self.navigationController pushViewController:self.editStepController animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Can not upload image"];
            }
        }];
    } else {
        [self.navigationController pushViewController:self.editStepController animated:YES];
    }
}

#pragma mark delegates: UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageToBeUploaded = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageImageView.image = self.imageToBeUploaded;
    self.routeHasChanged = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark delegates: UIImagePickerControllerDelegate

- (void)routeCoverEditView:(RouteCoverEditView *)view didCancelEditingRoute:(Route *)route {
    [self hideRouteCoverEdit];
}

- (void)routeCoverEditView:(RouteCoverEditView *)view didSaveRoute:(Route *)route {
    [self loadDataFromRoute:route];
    self.routeHasChanged = YES;
    [self hideRouteCoverEdit];
}

#pragma mark private methods

- (void)onPickImageButtonTap {
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (void)onTakePicButtonTap {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    cameraUI.navigationBarHidden = NO;
    cameraUI.toolbarHidden = YES;
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;

    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (void) showRouteCoverEdit {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0, CGRectGetWidth(screen), 200);
    RouteCoverEditView *routeEditView = [[RouteCoverEditView alloc] initWithFrame:frame];
    routeEditView.route = self.route;
    routeEditView.delegate = self;
    CustomViewWithKeyboardAccessory *view = ((CustomViewWithKeyboardAccessory *)self.view);
    view.inputAccessoryView = routeEditView;

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

    [self.view becomeFirstResponder];
    [routeEditView.routeTitleTextField becomeFirstResponder];
}

- (void) hideRouteCoverEdit {
    //Remove focus from text field
    [self.view endEditing:NO];

    //Remove focus from editing box
    [self.view endEditing:YES];

    if (self.blurEffectView) {
        [self.blurEffectView removeFromSuperview];
    }
}

- (void)loadDataFromRoute:(Route *)route {
    [self.imageImageView setImageWithURL:route.imageUrl];

    self.titleLabel.text = [self checkValueFor:route.title missing:@"(New Ruote Title)"];
    NSString *location = [self checkValueFor:route.location missing:@"(Location)"];
    self.locationAuthorLabel.text = [NSString stringWithFormat:@"%@ \u2022 By @%@", location, route.author.username];
    self.descriptionLabel.text = [self checkValueFor:route.fullDescription missing:@"(New Route Description)"];

    if (route.places.count > 0) {
        NSMutableArray *placesNames = [[NSMutableArray alloc] init];
        for (Place *place in route.places) {
            if (place.name) {
                [placesNames addObject:place.name];
            }
        }

        self.placesListLabel.text = [placesNames componentsJoinedByString:@" \u2022 "];
    } else {
        self.placesListLabel.text = @"";
    }

    self.canProceedToPlaces = (route.title && route.title.length > 0) &&
                              (route.location && route.location.length > 0) &&
                              (route.fullDescription && route.fullDescription.length > 0);
    self.editPlacesButton.hidden = !self.canProceedToPlaces;
}

- (NSString *)checkValueFor:(NSString *)value missing:(NSString *)missing {
    if (!value || value.length == 0) {
        return missing;
    } else {
        return value;
    }
}

@end
