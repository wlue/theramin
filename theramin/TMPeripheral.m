//
//  TMPeripheral.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMPeripheral.h"

@implementation TMPeripheral

@dynamic name;
@dynamic uuid;
@dynamic rssi;

+ (NSString *)entityName
{
    return @"Peripheral";
}

@end
