//
//  RXAbstractAPIController.m
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-09.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

#import "RXAbstractAPIController.h"


#pragma mark - Public Interface

@interface RXAbstractAPIController ()

@property (nonatomic, strong) RXAbstractDataStoreController *dataController;

@end


#pragma mark - Implementation

@implementation RXAbstractAPIController

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.dataController = [self _instanceForDataController];

        NSAssert(self.dataController != nil, @"%@ does not have a data controller.", [self class]);
    }

    return self;
}

#pragma mark - Abstract

- (id)_instanceForDataController
{
    return nil;
}

#pragma mark - Public Methods

- (NSManagedObjectContext *)managedObjectContext
{
    return self.dataController.managedObjectContext;
}

@end
