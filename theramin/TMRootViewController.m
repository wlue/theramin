//
//  TMRootViewController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMRootViewController.h"
#import "TMDevicesViewController.h"


#pragma mark - Private Interface

@interface TMRootViewController () <TMDevicesViewControllerDelegate>

- (void)devicesButtonPressed:(id)sender;

@end


#pragma mark - Implementation

@implementation TMRootViewController

#pragma mark - Initialization

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    self.title = @"Theramin";

    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    [self loadMainView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Nearby Devices"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(devicesButtonPressed:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - TMDevicesViewControllerDelegate

- (void)devicesViewController:(TMDevicesViewController *)viewController
          didSelectPeripheral:(CBPeripheral *)peripheral
{

}

- (void)devicesViewControllerDidClose:(TMDevicesViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)devicesButtonPressed:(id)sender
{
    TMDevicesViewController *viewController = [[TMDevicesViewController alloc] init];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
