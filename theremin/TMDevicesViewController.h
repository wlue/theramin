//
//  TMDevicesViewController.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMViewController.h"

@protocol TMDevicesViewControllerDelegate;


@interface TMDevicesViewController : TMViewController

@property (nonatomic, weak) id <TMDevicesViewControllerDelegate> delegate;

@end


@protocol TMDevicesViewControllerDelegate

- (void)devicesViewController:(TMDevicesViewController *)viewController
          didSelectPeripheral:(CBPeripheral *)peripheral;

- (void)devicesViewControllerDidClose:(TMDevicesViewController *)viewController;

@end
