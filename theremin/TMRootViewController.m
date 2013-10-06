//
//  TMRootViewController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMRootViewController.h"
#import "TMPeripheral.h"
#import "TMEngineController.h"
#import "TMDevicesViewController.h"
#import "TMBluetoothController.h"

#pragma mark - Definitions

static void *TMPitchPeripheralKey = &TMPitchPeripheralKey;
static void *TMPitchPeripheralRSSIKey = &TMPitchPeripheralRSSIKey;

#pragma mark - Private Interface

@interface TMRootViewController () <TMDevicesViewControllerDelegate>

@property (nonatomic, strong) TMPeripheral *pitchPeripheral;
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

    [self addObserver:self forKeyPath:RXSelfKeyPath(pitchPeripheral) options:NSKeyValueObservingOptionOld context:TMPitchPeripheralKey];

    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:RXSelfKeyPath(pitchPeripheral) context:TMPitchPeripheralKey];

    if (self.pitchPeripheral) {
       [self.pitchPeripheral removeObserver:self forKeyPath:RXKeyPath(self.pitchPeripheral, rssi) context:TMPitchPeripheralRSSIKey];
    }
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == TMPitchPeripheralKey) {
        if (self.pitchPeripheral != nil) {
            [self.pitchPeripheral addObserver:self
                                   forKeyPath:RXKeyPath(self.pitchPeripheral, rssi)
                                      options:NSKeyValueObservingOptionInitial
                                      context:TMPitchPeripheralRSSIKey];
        } else {
            NSLog(@"Change: %@", change);
            TMPeripheral *peripheral = nil; // TODO
            [peripheral removeObserver:self
                                      forKeyPath:RXKeyPath(self.pitchPeripheral, rssi)
                                         context:TMPitchPeripheralRSSIKey];
        }
    } else if (context == TMPitchPeripheralRSSIKey) {
        TMPeripheral *peripheral = object;
        NSInteger rssi = peripheral.rssi.integerValue;
        if (rssi == 127) {
            return;
        }

        static const NSInteger ROLLING_SIZE = 5;
        static NSMutableArray *rolling = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            rolling = [[NSMutableArray alloc] initWithCapacity:ROLLING_SIZE];
        });

        NSInteger lower = 220;
        NSInteger upper = 880;

        NSInteger rLower = -60;
        NSInteger rUpper = -10;

        if (rolling.count >= 10) {
            [rolling removeLastObject];
        }
        [rolling insertObject:@(rssi) atIndex:0];

        double rollingRSSI = 0;
        for (NSNumber *roll in rolling) {
            rollingRSSI += roll.doubleValue;
        }
        rollingRSSI /= rolling.count;

        double progress = ((double)RXBoundedValue(rollingRSSI, rLower, rUpper) - rLower) / (rUpper - rLower);
        double freq = lower + (upper - lower) * progress;

        [[TMEngineController sharedInstance] setFrequency:freq];

        NSLog(@"Rolling RSSI change: %f, %d", rollingRSSI, rssi);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - TMDevicesViewControllerDelegate

- (void)devicesViewController:(TMDevicesViewController *)viewController
          didSelectPeripheral:(TMPeripheral *)peripheral
{
    NSLog(@"Selected Peripheral: %@", peripheral);

    self.pitchPeripheral = peripheral;

    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)volumeSliderChanged:(id)sender
{
    UISlider *slider = sender;

    [[TMEngineController sharedInstance] setVolume:slider.value];
}

@end
