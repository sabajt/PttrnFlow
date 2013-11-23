//
//  GameConstants.m
//  SequencerGame
//
//  Created by John Saba on 1/20/13.
//
//

#import "GameConstants.h"

// size
CGFloat const kSizeGridUnit = 80.0;
CGFloat const kStatusBarHeight = 20.0;

// duration
ccTime const kTransitionDuration = 0.25;

// notifications
NSString *const kNotificationRemoveTickReponder = @"removeTickResponder";
NSString *const kNotificationStartPan = @"startPan";
NSString *const kNotificationLockPan = @"lockPan";
NSString *const kNotificationUnlockPan = @"unlockPan";

// frame names
NSString *const kClearRectUILayer = @"clear_rect_uilayer.png";
NSString *const kClearRectAudioBatch = @"clear_rect_audio_batch.png";

@implementation GameConstants

@end