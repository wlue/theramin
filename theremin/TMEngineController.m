//
//  TMEngineController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-06.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMEngineController.h"

@implementation TMEngineController

#pragma mark - Class Methods

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Initialization

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    self.audioController =
        [[AEAudioController alloc] initWithAudioDescription:
            [AEAudioController nonInterleaved16BitStereoAudioDescription]];
    
//    self.player = [[MSFilePlayer alloc] initWithEngineController:self.audioController error:nil];
//    [self.audioController addChannels:@[self.player]];

    NSError *error = nil;
    [self.audioController start:&error];
    if (error) {
        NSLog(@"Could not instantiate: %@", error);
    }

    return self;
}

#pragma mark - Public Methods

- (void)play
{

}

- (void)stop
{

}

@end
