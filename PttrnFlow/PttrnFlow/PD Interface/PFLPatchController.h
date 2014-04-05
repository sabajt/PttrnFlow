//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "cocos2d.h"
#import "AVAudioPlayer+Utils.h"

@interface PFLPatchController : CCNode <AVAudioPlayerDelegate>

@property (assign) CGFloat beatDuration;

+ (PFLPatchController *)sharedMainSynth;
+ (void)mute:(BOOL)mute;

- (void)loadSamples:(NSArray *)samples;
- (void)receiveEvents:(NSArray *)events;

@end
