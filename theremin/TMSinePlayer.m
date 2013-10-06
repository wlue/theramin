//
//  TMSinePlayer.m
//  theremin
//
//  Created by Wen-Hao Lue on 2013-10-06.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMSinePlayer.h"

@interface TMSinePlayer () {
    double _theta;
    double _sampleRate;
}

@end

#pragma mark - Implementation

@implementation TMSinePlayer

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _playing = NO;
    _theta = 0.0;
    _frequency = 440.0;
    _sampleRate = 44100.0;

    return self;
}

- (AEAudioControllerRenderCallback)renderCallback
{
    return &GenerateTone;
}

static OSStatus GenerateTone(
    TMSinePlayer *THIS,
    AEAudioController *audioController,
    const AudioTimeStamp *time,
    UInt32 frames,
    AudioBufferList *audio
) {
    const double amplitude = 0.25;

    if (!THIS->_playing) {
        return noErr;
    }

    double theta = THIS->_theta;
    double thetaIncrement = 2.0 * M_PI * (THIS->_frequency / THIS->_sampleRate);
 
    Float32 *buffer = (Float32 *)audio->mBuffers[0].mData;
    for (UInt32 frame = 0; frame < frames; frame++) {
        buffer[frame] = (Float32)round((sin(theta) * amplitude));

        theta += thetaIncrement;
        if (theta > 2.0 * M_PI) {
            theta -= 2.0 * M_PI;
        }
    }
     
    THIS->_theta = theta;

    return noErr;
}

@end

