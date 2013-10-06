//
//  TMRootViewController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMRootViewController.h"
#import "TMEngineController.h"
#import "TMDevicesViewController.h"
#import "TMBluetoothController.h"


#pragma mark - Private Interface

@interface TMRootViewController () <TMDevicesViewControllerDelegate>

- (void)devicesButtonPressed:(id)sender;
- (void)modeSwitchDidChange:(id)sender;

@end


#pragma mark - Implementation

@implementation TMRootViewController

#pragma mark - Initialization

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    self.title = @"Theremin";

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

    UISwitch *modeSwitch = [[UISwitch alloc] init];
    modeSwitch.on = ([[TMBluetoothController sharedInstance] mode] == TMBluetoothModeCentral);
    [modeSwitch addTarget:self action:@selector(modeSwitchDidChange:) forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem *switchItem = [[UIBarButtonItem alloc] initWithCustomView:modeSwitch];
    self.navigationItem.leftBarButtonItem = switchItem;

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Nearby Devices"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(devicesButtonPressed:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[TMEngineController sharedInstance] play];
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

- (void)modeSwitchDidChange:(id)sender
{
    UISwitch *switchView = sender;

    TMBluetoothController *controller = [TMBluetoothController sharedInstance];
    if (switchView.on) {
        NSLog(@"Switch mode to Central.");

        controller.mode = TMBluetoothModeCentral;
        [controller stopBroadcasting];
    } else {
        NSLog(@"Switch mode to Peripheral.");

        controller.mode = TMBluetoothModePeripheral;
        [controller startBroadcasting];
    }
}

@end
