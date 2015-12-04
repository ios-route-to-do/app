//
//  RouteCoverEditViewController.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/19/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "RouteCoverEditViewController.h"
#import "RouteStepViewController.h"
#import "Place.h"
#import "CNPPopupController.h"
#import "BackendRepository.h"

@interface RouteCoverEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNPPopupControllerDelegate> {
    UIImagePickerController *ipc;
//    UIPopoverController *popover;
}

@property (weak, nonatomic) IBOutlet UIButton *startRouteButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesListLabel;

@property (nonatomic) RouteStepViewController *nextStepController;
@property (nonatomic) UIBarButtonItem *likeButton;

@property (weak, nonatomic) IBOutlet UITextField *routeTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *routeLocationTextField;
@property (weak, nonatomic) IBOutlet UITextView *routeDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *routeEditionView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionCharCountLabel;

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

    [self.routeEditionView removeFromSuperview];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onPickImageButtonTap:(id)sender {
    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:ipc animated:YES completion:nil];
}
- (IBAction)onTakePicButtonTap:(id)sender {
    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imageImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEditRouteButtonTap:(id)sender {
    CNPPopupController *editPopupController = [[CNPPopupController alloc] initWithContents:@[self.routeEditionView]];

    editPopupController.theme = [CNPPopupTheme defaultTheme];
    editPopupController.theme.popupStyle = CNPPopupStyleCentered;
    editPopupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    editPopupController.theme.cornerRadius = 20.0f;
    editPopupController.theme.popupContentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);


    editPopupController.theme.contentVerticalPadding = 0.0f;
    editPopupController.delegate = self;
    [editPopupController presentPopupControllerAnimated:YES];
//    [self.routeTitleTextField becomeFirstResponder];
//    [self.view layoutIfNeeded];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.routeEditionView.alpha = 1;
//        self.editViewConstraint.constant = 60;
//        [self.view layoutIfNeeded];
//    }];
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
