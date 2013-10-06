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

    self.volume = 0.0f;

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

- (void)setVolume:(float)volume
{
    _volume = volume;
    self.player.volume = volume;
}

#pragma mark - Public Methods

- (void)play
{
    self.player.playing = YES;
    self.frequency = 440.0;
    self.volume = 0.0;
}

- (void)stop
{
    self.player.playing = NO;
}

@end
