//
//  TMEngineController.h
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-06.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

@interface TMEngineController : NSObject

@property (nonatomic, strong) AEAudioController *audioController;

+ (instancetype)sharedInstance;

- (void)play;
- (void)stop;

@end
