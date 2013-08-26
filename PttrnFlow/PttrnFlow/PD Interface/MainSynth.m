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
#import "SynthEvent.h"
#import "AudioStopEvent.h"

static NSString *const kActivateNoise = @"activateNoise";
static NSString *const kActiviateDrum = @"activateDrum";
static NSString *const kClear = @"clear";
static NSString *const kTrigger = @"trigger";
static NSString *const kMidiValue = @"midinote";
static NSString *const kSelectDrum = @"selectDrum";
static NSString *const kMute = @"mute";
static NSString *const kSynthEvent = @"prepareSynth";
static NSString *const kAudioStop = @"audioStop";


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
        NSLog(@"no events sent to synth");
        return;
    }
    
    // clearing blocks input for various pd components / channels unless we recieve an event for it below
    [PdBase sendBangToReceiver:kClear];
    
    // send events (setup information) in
    for (TickEvent *event in events) {
        
        if ([event isKindOfClass:[SynthEvent class]]) {
            SynthEvent *synth = (SynthEvent *)event;
            NSNumber *midiValue = [NSNumber numberWithInt:[synth.midiValue intValue]];
            NSNumber *channel = [NSNumber numberWithInt:[synth.channel intValue]];
            [PdBase sendList:@[synth.synthType, midiValue, channel] toReceiver:kSynthEvent];
        }
        
        if ([event isKindOfClass:[AudioStopEvent class]]) {
            AudioStopEvent *audioStop = (AudioStopEvent *)event;
            [PdBase sendFloat:[audioStop.channel floatValue] toReceiver:kAudioStop];
        }
    }
    
    // play the synth with everything setup the way we want
    [PdBase sendBangToReceiver:kTrigger];
}

@end