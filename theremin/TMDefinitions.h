//
//  TMDefinitions.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "NSManagedObject+RXAdditions.h"
#import "NSManagedObjectContext+RXAdditions.h"
#import "UIView+RXAdditions.h"

#if DEBUG
    #define NSDebugLog(fmt, ...) NSLog(fmt, __VA_ARGS__)
    #define NSDebugAssert(condition, ...) NSAssert((condition), __VA_ARGS__)
#else
    #define NSDebugLog(fmt, ...)
    #define NSDebugAssert(condition, ...) 
#endif

#define RXBlockCat(A, B) A##B
#define RXBlockSafe(property) __weak __typeof__(property) RXBlockCat(b, property) = property

#define RXKeyPath(object, keyPath) ((void)(NO && ((void)object.keyPath, NO)), @#keyPath)
#define RXSelfKeyPath(keyPath) RXKeyPath(self, keyPath)
#define RXTypedKeyPath(ObjectClass, keyPath) RXKeyPath(((ObjectClass *)nil), keyPath)
#define RXProtocolKeyPath(Protocol, keyPath) RXKeyPath(((id <Protocol>)nil), keyPath)

#define RXScreenScaledValue(value) ((value) / [[UIScreen mainScreen] scale])

#define RXBoundedValue(value, minValue, maxValue) MIN(maxValue, MAX(minValue, value))
#define RXBoundedPercent(value) RXBoundedValue(value, 0.0f, 1.0f)

#define RXIsEqual(first, second) (((first) && [(first) isEqual:(second)]) || (!(first) && !(second)))

#define RXObfuscated(...) RXReversedString(@[__VA_ARGS__])
#define RXObfuscatedClass(...) NSClassFromString(RXReversedString(@[__VA_ARGS__]))

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << (howmuch)) | (((NSUInteger)val) >> (NSUINT_BIT - (howmuch))))


#define TM_PERIPHERAL_UUID @"37A1EC85-6B0F-4AD1-9C41-1604FDDAFF25"

//
// Utility Functions
//

double RXFloorTo(double value, double nearest);
double RXCeilTo(double value, double nearest);

BOOL ObjectIsNSNull(id object);
id RXObjectOrNil(id object);
id RXObjectOrNull(id object);

CGRect CGRectCenteredInRect(CGRect outerRect, CGRect innerRect, BOOL integral);

NSString *RXReversedString(NSArray *array);

CGRect CGRectExtendEdge(CGRect rect, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left);
