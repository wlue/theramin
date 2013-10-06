//
//  TMBluetoothController.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

typedef NS_ENUM(NSInteger, TMBluetoothMode) {
    TMBluetoothModeCentral      = 0,
    TMBluetoothModePeripheral   = 1
};


@interface TMBluetoothController : NSObject

@property (nonatomic, assign) TMBluetoothMode mode;

+ (instancetype)sharedInstance;

- (void)startScanning;
- (void)stopScanning;

- (void)startBroadcasting;
- (void)stopBroadcasting;

@end
