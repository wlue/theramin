//
//  TMBluetoothController.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

@class TMPeripheral;
@protocol TMBluetoothPeripheralSubscriber;

#pragma mark - Definitions

extern NSString *const TMBluetoothPeripheralConnectedNotification;
extern NSString *const TMBluetoothPeripheralDisconnectedNotification;

typedef NS_ENUM(NSInteger, TMBluetoothMode) {
    TMBluetoothModeCentral      = 0,
    TMBluetoothModePeripheral   = 1
};


#pragma mark - Public Interface

@interface TMBluetoothController : NSObject

@property (nonatomic, assign) TMBluetoothMode mode;

+ (instancetype)sharedInstance;

- (void)subscribeObject:(id <TMBluetoothPeripheralSubscriber>)object toRSSIForPeripheral:(CBPeripheral *)peripheral;
- (void)unsubscribeObject:(id <TMBluetoothPeripheralSubscriber>)object toRSSIForPeripheral:(CBPeripheral *)peripheral;

- (void)startScanning;
- (void)stopScanning;

- (void)connectPeripheral:(TMPeripheral *)peripheralModel;

- (void)startBroadcasting;
- (void)stopBroadcasting;

@end


#pragma mark - Subscriber Protocol

@protocol TMBluetoothPeripheralSubscriber <NSObject>

- (void)bluetoothController:(TMBluetoothController *)controller didUpdatePeripheral:(CBPeripheral *)peripheral;

@end