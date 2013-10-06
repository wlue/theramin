//
//  RXAbstractDataStoreController.m
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-09.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

#import "RXAbstractDataStoreController.h"


#pragma mark - Private Interface

@interface RXAbstractDataStoreController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *storeType;
@property (nonatomic, strong) NSSet *managedObjectModelPaths;
@property (nonatomic, strong) NSString *persistentStorePath;

- (void)loadManagedObjectContext;
- (void)loadManagedObjectModel;
- (void)loadPersistentStoreCoordinator;

@end


#pragma mark - Implementation

@implementation RXAbstractDataStoreController

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.storeType = [self _coreDataStoreType];
        self.managedObjectModelPaths = [self _pathsForManagedObjectModel];
        self.persistentStorePath = [self _pathForPersistentStore];

        [self loadManagedObjectModel];
    }

    return self;
}

#pragma mark - Abstract Methods

+ (id)sharedInstance
{
    return nil;
}

- (NSString *)_coreDataStoreType
{
    return NSSQLiteStoreType;
}

- (NSSet *)_pathsForManagedObjectModel
{
    return nil;
}

- (NSString *)_pathForPersistentStore
{
    return nil;
}

- (BOOL)_shouldClearPersistentStoreOnModelUpdate
{
    return NO;
}

#pragma mark - Public Methods

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        [self loadManagedObjectContext];
    }

    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        [self loadPersistentStoreCoordinator];
    }

    return _persistentStoreCoordinator;
}

- (void)ensureModelCompatibility
{
    // Force load the managed object context, and consequently, the persistent store coordinator to check for
    // model incompatibility.
    [self managedObjectContext];
}

- (void)deletePersistentStore
{
    [_managedObjectContext reset];
    self.managedObjectContext = nil;
    self.persistentStoreCoordinator = nil;

    [[NSFileManager defaultManager] removeItemAtPath:self.persistentStorePath error:NULL];
}


#pragma mark - Private Methods

- (void)loadManagedObjectContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    if (self.persistentStoreCoordinator) {
        context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }

    context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    context.undoManager = nil;
    self.managedObjectContext = context;
}

- (void)loadManagedObjectModel
{
    NSMutableArray *managedObjectModels = [NSMutableArray array];
    for (NSString *managedObjectModelPath in self.managedObjectModelPaths) {
        NSManagedObjectModel *model = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:managedObjectModelPath]) {
            model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:managedObjectModelPath]];
            model = [NSManagedObjectModel modelByMergingModels:@[model]];
        }

        if (model) {
            [managedObjectModels addObject:model];
        }
    }

    self.managedObjectModel = [NSManagedObjectModel modelByMergingModels:managedObjectModels];
}

- (void)loadPersistentStoreCoordinator
{
    NSURL *storeURL = [NSURL fileURLWithPath:self.persistentStorePath];

    // If there is a model incompatibility, then figure out if we want to delete the persistent store.
    if ([self _shouldClearPersistentStoreOnModelUpdate]) {
        Class persistentStoreClass = [[NSPersistentStoreCoordinator registeredStoreTypes][self.storeType] pointerValue];
        NSDictionary *metadata = [persistentStoreClass metadataForPersistentStoreWithURL:storeURL error:NULL];

        // Delete the persistent store file if there is an incompatibility.
        if (metadata && ![self.managedObjectModel isConfiguration:nil compatibleWithStoreMetadata:metadata]) {

            NSLog(@"Notice: Model incompatibility or forced deletion for %@ data store is triggering a persistent store deletion.", [self class]);
            [[NSFileManager defaultManager] removeItemAtPath:self.persistentStorePath error:NULL];
            NSLog(@"Notice: Removed %@", self.persistentStorePath);
        }
    }

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{
        NSMigratePersistentStoresAutomaticallyOption: @YES,
        NSInferMappingModelAutomaticallyOption: @YES
    };

    NSError *error = nil;
    if (![coordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error: %@", [error userInfo]);
        abort();
    }

    self.persistentStoreCoordinator = coordinator;
}

@end
