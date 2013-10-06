//
//  TMSinePlayer.h
//  theremin
//
//  Created by Wen-Hao Lue on 2013-10-06.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

@interface TMSinePlayer : NSObject <AEAudioPlayable>

@property (nonatomic, assign) BOOL playing;

@property (nonatomic, assign) double frequency;
@property (nonatomic, assign) float volume;

@end
