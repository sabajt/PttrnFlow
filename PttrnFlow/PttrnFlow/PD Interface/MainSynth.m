//
//  MainSynth.m
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "MainSynth.h"
#import "PdDispatcher.h"
#import "SequenceLayer.h"
#import "TickDispatcher.h"
#import "TickEvent.h"

static NSString *const kActivateTone = @"activateTone";
static NSString *const kActivateNoise = @"activateNoise";
static NSString *const kActiviateDrum = @"activateDrum";
static NSString *const kClear = @"clear";
static NSString *const kTrigger = @"trigger";
static NSString *const kMidiValue = @"midinote";
static NSString *const kSelectDrum = @"selectDrum";
static NSString *const kMute = @"mute";


@implementation MainSynth

+ (void)mute:(BOOL)mute
{
    float muteVal = 1.0;
    if (mute) {
        muteVal = 0.0;
    }
    [PdBase sendFloat:muteVal toReceiver:kMute];
}

#pragma mark - SoundEventReveiver

+ (void)receiveEvents:(NSArray *)events
{
    if ((events == nil) || (events.count < 1)) {
        NSLog(@"warning: no events sent to synth");
        return;
    }    
    [PdBase sendBangToReceiver:kClear];
    
    for (TickEvent *event in events) {
        
//        if ([event isEqualToString:kExitEvent]) {
//            [PdBase sendBangToReceiver:kActivateNoise];
//        }
//        
//        if ([MainSynth isValidMidiValue:event]) {
//            [PdBase sendBangToReceiver:kActivateTone];
//            [PdBase sendFloat:[event intValue] toReceiver:kMidiValue];
//        }
//        
//        if ([MainSynth isValidDrumPattern:event]) {
//            [PdBase sendSymbol:event toReceiver:kSelectDrum];
//            [PdBase sendBangToReceiver:kActiviateDrum];
//        }
//        
////        if ([TickDispatcher isArrowEvent:event]) {
////            [PdBase sendBangToReceiver:kActivateNoise];
////        }
    }
    
    [PdBase sendBangToReceiver:kTrigger];
}

@end