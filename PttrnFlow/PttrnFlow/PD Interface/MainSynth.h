//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import <Foundation/Foundation.h>
#import "MultiSampleEvent.h"

typedef enum
{
    PFSynthTypePhasor = 0,
    PFSynthTypeOsc,
} PFSynthType;

@interface MainSynth : NSObject <MultiSampleEventDelegate>

+ (MainSynth *)sharedMainSynth;
+ (void)mute:(BOOL)mute;
- (void)loadSamples:(NSArray *)samples;
- (void)receiveEvents:(NSArray *)events ignoreAudioPad:(BOOL)ignoreAudioPad;

@end
