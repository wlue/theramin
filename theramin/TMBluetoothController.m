//
//  TMBluetoothController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMBluetoothController.h"

#pragma mark - Private Interface

@interface TMBluetoothController () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *central;

@end


#pragma mark -

@implementation TMBluetoothController

#pragma mark - Class Methods

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id singleton = nil;
    dispatch_once(&onceToken, ^{
        singleton = [[[self class] alloc] init];
    });

    return singleton;
}

#pragma mark - Initialization

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

   self.central = [[CBCentralManager alloc] initWithDelegate:self
                                                    queue:dispatch_get_main_queue()];

    return self;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Central updated state: %@", @(central.state));
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected with peripheral: %@", peripheral);
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered peripheral: %@", peripheral.name);
    NSLog(@"RSSI: %@", RSSI);
}

#pragma mark - Public Methods

- (void)startScanning
{
    NSLog(@"Start scanning for peripherals.");

    NSDictionary *options = @{
        CBCentralManagerScanOptionAllowDuplicatesKey: @YES
    };

    [self.central scanForPeripheralsWithServices:nil
                                         options:options];
}

#pragma mark - Private Methods


@end
