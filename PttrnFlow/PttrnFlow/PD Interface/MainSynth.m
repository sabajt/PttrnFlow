//
//  MainSynth.m
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "MainSynth.h"

#import "PuzzleDataManager.h"
#import "PdDispatcher.h"
#import "PuzzleLayer.h"
#import "TickEvent.h"
#import "SynthEvent.h"
#import "AudioStopEvent.h"
#import "AudioPadEvent.h"
#import "ExitEvent.h"
#import "SampleEvent.h"

static NSString *const kActivateNoise = @"activateNoise";
static NSString *const kClear = @"clear";
static NSString *const kTrigger = @"trigger";
static NSString *const kMidiValue = @"midinote";
static NSString *const kMute = @"mute";
static NSString *const kSynthEvent = @"synthEvent";
static NSString *const kAudioStop = @"audioStop";

static NSString *const kLoadSample = @"loadSample";
static NSString *const kStageSample = @"stageSample";

@interface MainSynth ()

@property (strong, nonatomic) NSMutableDictionary *sampleKey;

@end

@implementation MainSynth

+ (MainSynth *)sharedMainSynth
{
    static MainSynth *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MainSynth alloc] init];
    });
    return sharedInstance;
}

+ (void)mute:(BOOL)mute
{
    float muteVal = 1.0;
    if (mute) {
        muteVal = 0.0;
    }
    [PdBase sendFloat:muteVal toReceiver:kMute];
}

+ (PFSynthType)pfSynthTypeForStringRep:(NSString *)rep
{
    if ([rep isEqualToString:@"phasor"]) {
        return PFSynthTypePhasor;
    }
    else {
        return PFSynthTypeOsc;
    }
}

#pragma mark - SoundEventReveiver

- (void)loadSamples:(NSArray *)samples
{
    self.sampleKey = [NSMutableDictionary dictionary];
    NSInteger i = 1;
    for (NSString *sampleName in samples) {
        NSString *sampleSuffix = [NSString stringWithFormat:@"_%i", i];
        [self.sampleKey setObject:sampleSuffix forKey:sampleName];
        NSString *receiver = [kLoadSample stringByAppendingString:sampleSuffix];
        [PdBase sendList:@[sampleName, sampleSuffix] toReceiver:receiver];
        i++;
    }
}

// TODO: refactor to take out 'ignore audio pad' - there will never be a glyph without an audio pad
- (void)receiveEvents:(NSArray *)events ignoreAudioPad:(BOOL)ignoreAudioPad
{
    if ((events == nil) || (events.count < 1)) {
        CCLOG(@"no events sent to synth");
        return;
    }
    
    // clearing blocks input for various pd components / channels unless we recieve an event for it below
    [PdBase sendBangToReceiver:kClear];
    
    // audio pad is the 'island surface' where blocks live.  we ignore this for playing solution seq
    BOOL onAudioPad = ignoreAudioPad;
    
    // send events (setup information) in
    for (TickEvent *event in events) {
        
        if ([event isKindOfClass:[AudioPadEvent class]]) {
            onAudioPad = YES;
        }
        
        if ([event isKindOfClass:[SynthEvent class]]) {
            SynthEvent *synth = (SynthEvent *)event;
            NSNumber *midiValue = [NSNumber numberWithInt:[synth.midiValue intValue]];
            NSNumber *synthType = [NSNumber numberWithInt:[MainSynth pfSynthTypeForStringRep:synth.synthType]];
            [PdBase sendList:@[synthType, midiValue, @0] toReceiver:kSynthEvent];
        }
        
        if ([event isKindOfClass:[SampleEvent class]]) {
            SampleEvent *sample = (SampleEvent *)event;
            NSString *sampleSuffix = self.sampleKey[sample.fileName];
            NSString *receiver = [kStageSample stringByAppendingString:sampleSuffix];
            [PdBase sendBangToReceiver:receiver];
        }
        
        if([event isKindOfClass:[MultiSampleEvent class]]) {
            MultiSampleEvent *multiSample = (MultiSampleEvent *)event;
            
            // set up samples to be recieved with time delays
            [multiSample.samples enumerateKeysAndObjectsUsingBlock:^(NSNumber *time, SampleEvent *event, BOOL *stop) {
                CCCallBlock *action = [CCCallBlock actionWithBlock:^{
                    [self receiveEvents:@[event] ignoreAudioPad:YES];
                }];
                CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:[time floatValue] * self.beatDuration], action, nil];
                [self runAction:seq];
            }];
        }
        
        if ([event isKindOfClass:[AudioStopEvent class]]) {
            [PdBase sendFloat:[@0 floatValue] toReceiver:kAudioStop];
        }
        
        if ([event isKindOfClass:[ExitEvent class]]) {
            // first stop audio
            [PdBase sendFloat:[@0 floatValue] toReceiver:kAudioStop];
            
            // noise for exit event (currently channel independendant)
            ExitEvent *exitEvent = (ExitEvent *)exitEvent;
            [PdBase sendBangToReceiver:kActivateNoise];
            
            // also set onAudioPad so we'll trigger these events
            onAudioPad = YES;
        }
    }
    
    // play the synth with everything setup the way we want if we are on an audio pad
    if (onAudioPad) {
        [PdBase sendBangToReceiver:kTrigger];
    }
}

@end