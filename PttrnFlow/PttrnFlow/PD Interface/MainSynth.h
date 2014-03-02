//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import <Foundation/Foundation.h>
#import "Drum.h"

typedef enum
{
    PFSynthTypePhasor = 0,
    PFSynthTypeOsc,
} PFSynthType;

@interface MainSynth : NSObject <DrumDelegate>

+ (MainSynth *)sharedMainSynth;
+ (void)mute:(BOOL)mute;
- (void)loadSamples:(NSArray *)samples;
- (void)receiveEvents:(NSArray *)events ignoreAudioPad:(BOOL)ignoreAudioPad;

@end
