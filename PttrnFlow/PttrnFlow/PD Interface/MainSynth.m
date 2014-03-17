//
//  MainSynth.m
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "MainSynth.h"

#import "PdDispatcher.h"
#import "PuzzleLayer.h"
#import "PFLEvent.h"

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

- (void)receiveEvents:(NSArray *)events
{
    if ((events == nil) || (events.count < 1)) {
        CCLOG(@"no events sent to synth");
        return;
    }
    
    // clearing blocks input for various pd components / channels unless we recieve an event for it below
    [PdBase sendBangToReceiver:kClear];
    
    // send events (setup information) in
    for (PFLEvent *event in events) {
        
        if (event.eventType == PFLSequenceEventSynth) {
            NSNumber *midiValue = @([event.midiValue integerValue]);
        
            // TODO: synth type needs to be an enum on event or basic model
            NSNumber *synthType = @0;
            [PdBase sendList:@[synthType, midiValue, @0] toReceiver:kSynthEvent];
        }
        
        if (event.eventType == PFLSequenceEventSample) {
            NSString *sampleSuffix = self.sampleKey[event.file];
            NSString *receiver = [kStageSample stringByAppendingString:sampleSuffix];
            [PdBase sendBangToReceiver:receiver];
        }
        
        if(event.eventType == PFLSequenceEventMultiSample) {
            
            // set up samples to be recieved with time delays
            for (PFLEvent *sampleEvent in event.sampleEvents) {
                CCCallBlock *action = [CCCallBlock actionWithBlock:^{
                    [self receiveEvents:@[sampleEvent]];
                }];
                CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:[sampleEvent.time floatValue] * self.beatDuration], action, nil];
                [self runAction:seq];
            };
        }
        
        if (event.eventType == PFLSequenceEventAudioStop) {
            // TODO: was there a reason this is not 0.0f?
            [PdBase sendFloat:[@0 floatValue] toReceiver:kAudioStop];
        }
        
        if (event.eventType == PFLSequenceEventExit) {
            // TODO: was there a reason this is not 0.0f?
            [PdBase sendFloat:[@0 floatValue] toReceiver:kAudioStop];
        }
    }
    
    [PdBase sendBangToReceiver:kTrigger];
}

@end