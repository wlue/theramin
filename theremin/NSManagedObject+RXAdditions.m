//
//  NSManagedObject+RXAdditions.m
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-10.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

#import "NSManagedObject+RXAdditions.h"


@implementation NSManagedObject (RXAdditions)

+ (NSString *)entityName
{
    NSAssert(NO, @"Managed object does not implement entityName.");
    return nil;
}

+ (id)instanceFromManagedObjectContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

+ (NSFetchRequest *)createFetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:[[self class] entityName]];
}

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self initWithEntity:[NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:context] insertIntoManagedObjectContext:context];
}

- (BOOL)obtainPermanentObjectID
{
    if ([self.objectID isTemporaryID]) {
        return [self.managedObjectContext obtainPermanentIDsForObjects:[NSArray arrayWithObject:self] error:NULL];
    }

    return YES;
}

- (NSManagedObjectID *)permanentObjectID
{
    [self obtainPermanentObjectID];
    if ([self.objectID isTemporaryID]) {
        return nil;
    }

    return self.objectID;
}

@end
