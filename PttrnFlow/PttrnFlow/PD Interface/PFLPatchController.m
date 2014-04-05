//
//  MainSynth.m
//  SequencerGame
//
//  Created by John Saba on 5/5/13.
//
//

#import "PFLPatchController.h"
#import "PdDispatcher.h"
#import "PFLPuzzleLayer.h"
#import "PFLEvent.h"

@interface PFLPatchController ()

@property (strong, nonatomic) NSMutableDictionary *sampleKey;

@end

@implementation PFLPatchController

+ (PFLPatchController *)sharedMainSynth
{
    static PFLPatchController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PFLPatchController alloc] init];
    });
    return sharedInstance;
}

+ (void)mute:(BOOL)mute
{
    CCLOG(@"mute needs implementation");
}

#pragma mark - SoundEventReveiver

- (void)loadSamples:(NSArray *)samples
{
    self.sampleKey = [NSMutableDictionary dictionary];
    for (NSString *sampleName in samples) {
        NSArray *comp = [sampleName componentsSeparatedByString:@"."];
        NSURL *url = [[NSBundle mainBundle] URLForResource:comp[0] withExtension:comp[1]];
        AVAudioPlayer *audioPlayer = [AVAudioPlayer audioPlayerForURL:url];
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [self.sampleKey setObject:audioPlayer forKey:sampleName];
    }
}

- (void)receiveEvents:(NSArray *)events
{
    if ((events == nil) || (events.count < 1)) {
        CCLOG(@"no events sent to synth");
        return;
    }
  
    for (PFLEvent *event in events) {
        
        if (event.eventType == PFLEventTypeSynth) {
            NSNumber *midiValue = @([event.midiValue integerValue]);
            // TODO: synth type needs to be an enum on event or basic model
            NSNumber *synthType = @0;
        }
        
        if (event.eventType == PFLEventTypeSample) {
            AVAudioPlayer *audioPlayer = self.sampleKey[event.file];
            audioPlayer.currentTime = 0.0;
            [audioPlayer play];
        }
        
        if(event.eventType == PFLEventTypeMultiSample) {
            
            // set up samples to be recieved with time delays
            for (PFLEvent *sampleEvent in event.sampleEvents) {
                CCCallBlock *action = [CCCallBlock actionWithBlock:^{
                    [self receiveEvents:@[sampleEvent]];
                }];
                CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:[sampleEvent.time floatValue] * self.beatDuration], action, nil];
                [self runAction:seq];
            };
        }
        
        if (event.eventType == PFLEventTypeAudioStop) {;
        }
        
        if (event.eventType == PFLEventTypeExit) {
        }
    }
}

@end