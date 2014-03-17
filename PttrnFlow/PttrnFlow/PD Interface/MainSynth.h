//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "cocos2d.h"

@interface MainSynth : CCNode

@property (assign) CGFloat beatDuration;

+ (MainSynth *)sharedMainSynth;
+ (void)mute:(BOOL)mute;

- (void)loadSamples:(NSArray *)samples;
- (void)receiveEvents:(NSArray *)events;

@end
