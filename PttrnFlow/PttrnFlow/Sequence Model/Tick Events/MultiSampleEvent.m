//
//  MultiSampleEvent.m
//  PttrnFlow
//
//  Created by John Saba on 3/1/14.
//
//

#import "MultiSampleEvent.h"
#import "SampleEvent.h"
#import "MainSynth.h"

@interface MultiSampleEvent ()

@property (strong, nonatomic) NSMutableDictionary *samples;

@end

@implementation MultiSampleEvent

- (id)initWithAudioID:(NSNumber *)audioID timedSamplesData:(NSDictionary *)timedSamplesData
{
    self = [super init];
    if (self) {
        self.audioID = audioID;
        self.delegate = [MainSynth sharedMainSynth];
        
        self.samples = [NSMutableDictionary dictionary];
        [timedSamplesData enumerateKeysAndObjectsUsingBlock:^(NSNumber *time, NSString *file, BOOL *stop) {
            SampleEvent *event = [[SampleEvent alloc] initWithAudioID:audioID sampleName:file];
            self.samples[time] = event;
        }];
    }
    return self;
}

- (void)scheduleSamples
{
    // set up samples to be sent out with time delays
    [self.samples enumerateKeysAndObjectsUsingBlock:^(NSNumber *time, SampleEvent *event, BOOL *stop) {
        CCCallBlock *action = [CCCallBlock actionWithBlock:^{
            [self.delegate receiveSampleEvent:event];
        }];
        CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:[time floatValue]], action, nil];
        [self runAction:seq];
    }];

}

#pragma mark - Subclass hooks

- (NSString *)eventDescription
{
    __block NSString *sampleDescriptions = @"";
    [self.samples enumerateKeysAndObjectsUsingBlock:^(id key, SampleEvent *event, BOOL *stop) {
        sampleDescriptions = [sampleDescriptions stringByAppendingFormat:@"%@\n", [event eventDescription]];
    }];
    return [NSString stringWithFormat:@"%@: { audio ID : %@ } { containing sample events :\n%@\n}", self, self.audioID, sampleDescriptions];
}

@end
