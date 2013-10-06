//
//  RXAbstractDataStoreController.h
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-09.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

@interface RXAbstractDataStoreController : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong, readonly) NSString *storeType;

+ (id)sharedInstance;

- (void)ensureModelCompatibility;
- (void)deletePersistentStore;

#pragma mark Abstract   
- (NSString *)_coreDataStoreType;
- (NSSet *)_pathsForManagedObjectModel;
- (NSString *)_pathForPersistentStore;
- (BOOL)_shouldClearPersistentStoreOnModelUpdate;

@end
