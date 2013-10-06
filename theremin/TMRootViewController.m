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

@interface TMRootViewController () <TMDevicesViewControllerDelegate, TMBluetoothPeripheralSubscriber, CBPeripheralDelegate>

@property (nonatomic, strong) CBPeripheral *pitchPeripheral;
@property (nonatomic, strong) UISlider *volumeSlider;

- (void)devicesButtonPressed:(id)sender;
- (void)modeSwitchDidChange:(id)sender;
- (void)volumeSliderChanged:(id)sender;

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

    UISlider *slider = [[UISlider alloc] init];
    slider.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    slider.frameSize = CGSizeMake(280.0f, 50.0f);
    slider.center = self.view.center;
    slider.minimumValue = 0.0f;
    slider.maximumValue = 1.0f;

    [slider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:slider];
    self.volumeSlider = slider;
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
    self.volumeSlider.value = [[TMEngineController sharedInstance] volume];
}

#pragma mark - TMDevicesViewControllerDelegate

- (void)devicesViewController:(TMDevicesViewController *)viewController
          didSelectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Selected Peripheral: %@", peripheral);

    peripheral.delegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];

    [[TMBluetoothController sharedInstance] subscribeObject:self toRSSIForPeripheral:peripheral];
}

- (void)devicesViewControllerDidClose:(TMDevicesViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TMBluetoothPeripheralSubscriber

- (void)bluetoothController:(TMBluetoothController *)controller didUpdatePeripheral:(CBPeripheral *)peripheral
{
//    NSLog(@"Received sub message from %@ with RSSI %@", peripheral, peripheral.RSSI);
    [peripheral readRSSI];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"Peripheral RSSI Error: %@", error);
        return;
    }

    NSLog(@"Peripheral updated RSSI: %@", peripheral.RSSI);
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

- (void)volumeSliderChanged:(id)sender
{
    UISlider *slider = sender;

    [[TMEngineController sharedInstance] setVolume:slider.value];
}

@end
