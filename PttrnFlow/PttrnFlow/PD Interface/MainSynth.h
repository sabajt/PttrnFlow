//
//  MainSynth.h
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    PFSynthTypePhasor = 0,
    PFSynthTypeOsc,
} PFSynthType;

@interface MainSynth : NSObject

+ (void)receiveEvents:(NSArray *)events ignoreAudioPad:(BOOL)ignoreAudioPad;
+ (void)mute:(BOOL)mute;

@end
