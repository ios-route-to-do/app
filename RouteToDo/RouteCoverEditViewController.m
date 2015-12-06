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
#import "RouteStepViewController.h"
#import "Place.h"
#import "CNPPopupController.h"
#import "BackendRepository.h"

@interface RouteCoverEditViewController () <CNPPopupControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startRouteButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesListLabel;

@property (nonatomic) RouteStepViewController *nextStepController;
@property (nonatomic) UIBarButtonItem *likeButton;

@end




@implementation RouteCoverEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    self.nextStepController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    //Transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.startRouteButton.layer.cornerRadius = self.startRouteButton.frame.size.height / 2;
    self.startRouteButton.layer.masksToBounds = YES;

    if (self.route != nil) {
        [self loadDataFromRoute:self.route];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onPickImageButtonTap:(id)sender {
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    cameraUI.delegate = self;
    
    NSLog(@"here library");
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (IBAction)onTakePicButtonTap:(id)sender {
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEditRouteButtonTap:(id)sender {
    RouteCoverEditView *routeEditView = [[RouteCoverEditView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    CNPPopupController *editPopupController = [[CNPPopupController alloc] initWithContents:@[routeEditView]];

    editPopupController.theme = [CNPPopupTheme defaultTheme];
    editPopupController.theme.popupStyle = CNPPopupStyleFullscreen;
    editPopupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    editPopupController.theme.cornerRadius = 20.0f;
//    editPopupController.theme.popupContentInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);


    editPopupController.theme.contentVerticalPadding = 0.0f;
    editPopupController.delegate = self;
    [editPopupController presentPopupControllerAnimated:YES];
}

- (IBAction)onStartRouteButtonTap:(UIButton *)sender {
    if (self.nextStepController == nil) {
        self.nextStepController = [[RouteStepViewController alloc] init];
        self.nextStepController.route = self.route;
        self.nextStepController.step = 0;
    }

    [self.navigationController pushViewController:self.nextStepController animated:YES];
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
