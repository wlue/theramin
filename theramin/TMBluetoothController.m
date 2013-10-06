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

@interface TMBluetoothController () <CBCentralManagerDelegate, CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *central;
@property (nonatomic, strong) CBPeripheralManager *peripheral;

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

    NSString *UUID = [peripheral.identifier UUIDString];
    [self.context performBlock:^{
        NSFetchRequest *request = [TMPeripheral createFetchRequest];
        request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", RXTypedKeyPath(TMPeripheral, uuid), UUID];

        TMPeripheral *model = [[self.context executeFetchRequest:request] lastObject];
        if (!model) {
            model = [TMPeripheral instanceFromManagedObjectContext:self.context];
            model.name = peripheral.name;
            model.uuid = UUID;
        }

        model.rssi = RSSI;

        [self.context save];
    }];
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"Peripheral did update state: %@", @(peripheral.state));


}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error
{
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }

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

#pragma mark - Public Methods

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

- (void)startBroadcasting
{
    if (!self.peripheral) {
        self.peripheral = [[CBPeripheralManager alloc] initWithDelegate:self queue:self.queue];
    }

    CBUUID *UUID = [CBUUID UUIDWithString:TM_PERIPHERAL_UUID];
    [self.peripheral startAdvertising:@{
        CBAdvertisementDataServiceUUIDsKey: @[UUID]
    }];
}

- (void)stopBroadcasting
{

}

#pragma mark - Private Methods

- (void)updatePeripheral:(CBPeripheral *)peripheral withRSSI:(NSNumber *)RSSI
{
    
}

@end
