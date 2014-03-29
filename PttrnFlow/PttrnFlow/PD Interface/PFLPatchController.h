//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "cocos2d.h"

@interface PFLPatchController : CCNode

@property (assign) CGFloat beatDuration;

+ (PFLPatchController *)sharedMainSynth;
+ (void)mute:(BOOL)mute;

- (void)loadSamples:(NSArray *)samples;
- (void)receiveEvents:(NSArray *)events;

@end
