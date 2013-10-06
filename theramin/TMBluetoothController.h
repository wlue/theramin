//
//  TMBluetoothController.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBluetoothController : NSObject

+ (instancetype)sharedInstance;

- (void)startScanning;

@end
