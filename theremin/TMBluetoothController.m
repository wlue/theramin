//
//  TMBluetoothController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMBluetoothController.h"
#import "TMPeripheral.h"
#import "TMDevicesAPIController.h"

#pragma mark - Private Interface

@interface TMBluetoothController () <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *central;
@property (nonatomic, strong) CBPeripheralManager *peripheral;

@property (nonatomic, strong) NSMutableDictionary *deviceMap;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) NSManagedObjectContext *context;

- (void)updatePeripheral:(CBPeripheral *)peripheral withRSSI:(NSNumber *)RSSI;

@end


#pragma mark - Implementation

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

    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L);
    self.context = [[TMDevicesAPIController sharedInstance] managedObjectContext];
    self.deviceMap = [[NSMutableDictionary alloc] init];

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

    peripheral.delegate = self;
    [peripheral readRSSI];

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect with peripheral: %@", [error localizedDescription]);
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
//    NSLog(@"Discovered peripheral: %@", peripheral.name);
//    NSLog(@"RSSI: %@", RSSI);

    NSString *UUID = [peripheral.identifier UUIDString];
    [self.context performBlock:^{
        NSFetchRequest *request = [TMPeripheral createFetchRequest];
        request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", RXTypedKeyPath(TMPeripheral, uuid), UUID];

        TMPeripheral *model = [[self.context executeFetchRequest:request] lastObject];
        if (!model) {
            if (RSSI.integerValue != 127) {
                model = [TMPeripheral instanceFromManagedObjectContext:self.context];
                model.name = peripheral.name;
                model.uuid = UUID;
                model.rssi = RSSI;

                self.deviceMap[UUID] = peripheral;
            }
        } else {
            if (RSSI.integerValue == 127) {
                [self.context deleteObject:model];
                [self.deviceMap removeObjectForKey:model.uuid];
            } else {
                model.rssi = RSSI;
            }
        }

        [self.context save];
    }];
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"Peripheral RSSI Error: %@", [error localizedDescription]);
        return;
    }

    NSLog(@"Peripheral updated RSSI: %@", peripheral.RSSI);
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"Peripheral did update state: %@", @(peripheral.state));

    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Begin advertising.");

        CBUUID *UUID = [CBUUID UUIDWithString:TM_PERIPHERAL_UUID];
        [self.peripheral startAdvertising:@{
            CBAdvertisementDataLocalNameKey: @"Theremin",
            CBAdvertisementDataServiceUUIDsKey: @[UUID]
        }];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error
{
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
        return;
    }

    NSLog(@"Started advertising.");
}

#pragma mark - Properties

- (void)setMode:(TMBluetoothMode)mode
{
    if (mode == _mode) {
        return;
    }

    _mode = mode;

    if (_mode == TMBluetoothModeCentral) {
        self.peripheral = nil;
    } else {
        self.central = nil;
    }
}

#pragma mark - CBPeripheralDelegate


#pragma mark - Public Methods

#pragma mark Central Mode

- (void)startScanning
{
    if (!self.central) {
        self.central = [[CBCentralManager alloc] initWithDelegate:self
                                                            queue:self.queue];
    }

    NSLog(@"Start scanning for peripherals.");

    NSDictionary *options = @{
        CBCentralManagerScanOptionAllowDuplicatesKey: @YES
    };

    [self.central scanForPeripheralsWithServices:nil options:options];
}

- (void)stopScanning
{
    NSLog(@"Stop scanning for peripherals.");

    [self.central stopScan];
    [self.deviceMap removeAllObjects];

    // Delete all the stored devices first.
    [self.context performBlock:^{
        NSFetchRequest *request = [TMPeripheral createFetchRequest];
        
        NSArray *peripherals = [self.context executeFetchRequest:request];
        for (id peripheral in peripherals) {
            [self.context deleteObject:peripheral];
        }
        
        [self.context save];
    }];
}

- (void)connectPeripheral:(TMPeripheral *)peripheralModel
{
    CBPeripheral *peripheral = self.deviceMap[peripheralModel.uuid];
    if (!peripheral) {
        NSLog(@"Warning: Couldn't find and connect peripheral with UUID %@", peripheralModel.uuid);
        return;
    }

    [self.central connectPeripheral:peripheral options:nil];
}

#pragma mark Peripheral Mode

- (void)startBroadcasting
{
    if (!self.peripheral) {
        self.peripheral = [[CBPeripheralManager alloc] initWithDelegate:self queue:self.queue];
    }
}

- (void)stopBroadcasting
{
    [self.peripheral stopAdvertising];
    self.peripheral = nil;
}

#pragma mark - Private Methods

- (void)updatePeripheral:(CBPeripheral *)peripheral withRSSI:(NSNumber *)RSSI
{
    
}

@end
