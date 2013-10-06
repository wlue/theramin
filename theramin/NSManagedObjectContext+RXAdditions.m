//
//  NSManagedObjectContext+RXAdditions.m
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-10.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

#import "NSManagedObjectContext+RXAdditions.h"


@implementation NSManagedObjectContext (RXAdditions)

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
{
    NSError *error = nil;
    NSArray *result = [self executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error with fetch request: %@", [error localizedDescription]);
    }

    return result;
}

- (NSInteger)countForFetchRequest:(NSFetchRequest *)request
{
    NSError *error = nil;
    NSInteger result = [self countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error with count for fetch request: %@", [error localizedDescription]);
    }

    return result;
}

- (BOOL)save
{

#if DEBUG

    NSError *error = nil;
    BOOL result = [self save:&error];
    if (error != nil) {
        NSLog(@"Error in save: %@", error);
    }

    return result;

#else

    return [self save:NULL];

#endif

}

@end
