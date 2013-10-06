//
//  NSManagedObjectContext+RXAdditions.h
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-10.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

@interface NSManagedObjectContext (RXAdditions)

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request;
- (NSInteger)countForFetchRequest:(NSFetchRequest *)request;

- (BOOL)save;

@end
