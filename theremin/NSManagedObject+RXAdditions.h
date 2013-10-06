//
//  NSManagedObject+RXAdditions.h
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-10.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

@interface NSManagedObject (RXAdditions)

@property (nonatomic, strong, readonly) NSManagedObjectID *permanentObjectID;

+ (NSString *)entityName;
+ (id)instanceFromManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *)createFetchRequest;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (BOOL)obtainPermanentObjectID;

@end
