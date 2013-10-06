//
//  RXAbstractAPIController.h
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-09.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

#import "RXAbstractDataStoreController.h"

@interface RXAbstractAPIController : NSObject

@property (nonatomic, strong, readonly) RXAbstractDataStoreController *dataController;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

#pragma mark Abstract
- (id)_instanceForDataController;

@end
