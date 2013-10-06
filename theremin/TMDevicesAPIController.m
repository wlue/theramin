//
//  TMDevicesAPIController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMDevicesAPIController.h"
#import "TMDevicesDataController.h"

@implementation TMDevicesAPIController

#pragma mark - Class Methods

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

#pragma mark - RXAbstractAPIController

- (id)_instanceForDataController
{
    return [TMDevicesDataController sharedInstance];
}

@end
