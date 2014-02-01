//
//  GameConstants.m
//  SequencerGame
//
//  Created by John Saba on 1/20/13.
//
//

#import "GameConstants.h"

// sprite sheets
NSString *const kTextureKeySamplePads = @"samplePads";
NSString *const kTextureKeySynthPads = @"synthPads";
NSString *const kTextureKeyOther = @"other";
NSString *const kTextureKeyUILayer = @"uilayer";
NSString *const kTextureKeyBackground = @"background";
NSString *const kTextureKeyAudioObjects = @"audioObjects";

// directions
NSString *const kDirectionUp = @"up";
NSString *const kDirectionRight = @"right";
NSString *const kDirectionDown = @"down";
NSString *const kDirectionLeft = @"left";

// size
CGFloat const kSizeGridUnit = 68.0;
CGFloat const kStatusBarHeight = 20.0;

// duration
NSInteger const kBPM = 120;
ccTime const kTransitionDuration = 0.25;

// notifications
NSString *const kNotificationRemoveTickReponder = @"removeAudioResponder";
NSString *const kNotificationStartPan = @"startPan";
NSString *const kNotificationLockPan = @"lockPan";
NSString *const kNotificationUnlockPan = @"unlockPan";

// frame names
NSString *const kClearRectUILayer = @"clear_rect_uilayer.png";
NSString *const kClearRectAudioBatch = @"clear_rect_audio_batch.png";

@implementation GameConstants

@end