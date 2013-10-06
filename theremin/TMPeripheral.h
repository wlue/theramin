//
//  TMPeripheral.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "RXModel.h"

@interface TMPeripheral : RXModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSNumber *rssi;

@end
