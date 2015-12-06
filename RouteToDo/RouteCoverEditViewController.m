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

@interface RouteCoverEditViewController () <RouteCoverEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startRouteButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesListLabel;

@property (nonatomic) UIVisualEffectView *blurEffectView;
@property (nonatomic) RouteStepEditViewController *nextStepController;
@property (nonatomic) UIBarButtonItem *likeButton;

@end


@implementation RouteCoverEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideRouteCoverEdit)];
    [self.view addGestureRecognizer:recognizer];

    if (self.route != nil) {
        [self loadDataFromRoute:self.route];
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

    self.startRouteButton.layer.cornerRadius = self.startRouteButton.frame.size.height / 2;
    self.startRouteButton.layer.masksToBounds = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

# pragma mark events

- (IBAction)onEditRouteButtonTap:(id)sender {
    [self showRouteCoverEdit];
}

- (IBAction)onStartRouteButtonTap:(UIButton *)sender {
    if (self.nextStepController == nil) {
        self.nextStepController = [[RouteStepEditViewController alloc] init];
        self.nextStepController.route = self.route;
        self.nextStepController.step = 0;
    }

    [self.navigationController pushViewController:self.nextStepController animated:YES];
}

#pragma mark delegates: UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
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
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
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
    self.titleLabel.text = route.title;
    self.locationAuthorLabel.text = [NSString stringWithFormat:@"%@ \u2022 By @%@", route.location, route.author];
    self.informationLabel.text = [NSString stringWithFormat:@"%@ users \u2022 %.1f rating", route.usersCount, 4.0];
    self.descriptionLabel.text = route.fullDescription;
    
    NSMutableArray *placesNames = [[NSMutableArray alloc] init];
    for (Place *place in route.places) {
        [placesNames addObject:place.name];
    }
    self.placesListLabel.text = [placesNames componentsJoinedByString:@" \u2022 "];
}

@end
