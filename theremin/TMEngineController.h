//
//  TMEngineController.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-06.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

@interface TMEngineController : NSObject

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, assign) double frequency;
@property (nonatomic, assign) float volume;

+ (instancetype)sharedInstance;

- (void)play;
- (void)stop;

@end
