//
//  TMDevicesDataController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMDevicesDataController.h"

@implementation TMDevicesDataController

#pragma mark - Class Methods

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

#pragma mark - RXAbstractDataController

- (NSString *)_coreDataStoreType
{
    return NSInMemoryStoreType;
}

- (NSSet *)_pathsForManagedObjectModel
{
    return [NSSet setWithObjects:[[NSBundle mainBundle] pathForResource:@"Devices" ofType:@"momd"], nil];
}

- (NSString *)_pathForPersistentStore
{
    return nil;
}

- (BOOL)_shouldClearPersistentStoreOnModelUpdate
{
    return NO;
}

@end
