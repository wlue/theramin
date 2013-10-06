//
//  TMDevicesViewController.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMViewController.h"

@class TMPeripheral;
@protocol TMDevicesViewControllerDelegate;


@interface TMDevicesViewController : TMViewController

@property (nonatomic, weak) id <TMDevicesViewControllerDelegate> delegate;
@property (nonatomic, strong) id userInfo;

@end


@protocol TMDevicesViewControllerDelegate

- (void)devicesViewController:(TMDevicesViewController *)viewController
          didSelectPeripheral:(TMPeripheral *)peripheral;

- (void)devicesViewControllerDidClose:(TMDevicesViewController *)viewController;

@end
