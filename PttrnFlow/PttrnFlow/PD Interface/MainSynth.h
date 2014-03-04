//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "cocos2d.h"
#import "MultiSampleEvent.h"

typedef enum
{
    PFSynthTypePhasor = 0,
    PFSynthTypeOsc,
} PFSynthType;

@interface MainSynth : CCNode

+ (MainSynth *)sharedMainSynth;
+ (void)mute:(BOOL)mute;
- (void)loadSamples:(NSArray *)samples;
- (void)receiveEvents:(NSArray *)events ignoreAudioPad:(BOOL)ignoreAudioPad;

@end
