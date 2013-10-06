//
//  TMEngineController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-06.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMEngineController.h"
#import "TMSinePlayer.h"

#pragma mark - Private Interface

@interface TMEngineController ()

@property (nonatomic, strong) TMSinePlayer *player;

@end


#pragma mark - Implementation

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

    self.frequency = 440.0;
    self.audioController =
        [[AEAudioController alloc] initWithAudioDescription:
            [AEAudioController interleaved16BitStereoAudioDescription]];


    self.player = [[TMSinePlayer alloc] init];
    [self.audioController addChannels:@[self.player]];

    NSError *error = nil;
    [self.audioController start:&error];
    if (error) {
        NSLog(@"Could not instantiate: %@", error);
    }

    return self;
}

- (void)setFrequency:(double)frequency
{
    _frequency = frequency;
    self.player.frequency = frequency;
}

#pragma mark - Public Methods

- (void)play
{
    self.frequency = 440.0;
}

- (void)stop
{

}

@end
