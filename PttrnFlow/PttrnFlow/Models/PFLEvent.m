//
//  PFLEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "PFLKeyframe.h"
#import "PFLPuzzle.h"
#import "PFLPuzzleSet.h"
#import "PFLEvent.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"

NSString *const kChannelNone = @"ChannelNone";

@implementation NSArray (PFLEvent)

- (NSArray *)audioEvents
{
    NSMutableArray *filtered = [NSMutableArray array];
    for (PFLEvent *event in self) {
        if ([event isKindOfClass:[PFLEvent class]] && event.audioID) {
            [filtered addObject:event];
        }
    }
    return [NSArray arrayWithArray:filtered];
}

@end

@interface PFLEvent ()

@end

@implementation PFLEvent

// Individual event constructors
+ (id)synthEventWithAudioID:(NSNumber *)audioID midiValue:(NSString *)midiValue synthType:(NSString *)synthType
{
    PFLEvent *event = [[PFLEvent alloc] init];
    event.eventType = PFLEventTypeSynth;
    event.audioID = audioID;
    event.midiValue = midiValue;
    event.synthType = synthType;
    return event;
}

+ (id)sampleEventWithAudioID:(NSNumber *)audioID file:(NSString *)file time:(NSNumber *)time
{
    PFLEvent *event = [[PFLEvent alloc] init];
    event.eventType = PFLEventTypeSample;
    event.audioID = audioID;
    event.file = file;
    event.time = time;
    return event;
}

+ (id)directionEventWithDirection:(NSString *)direction
{
    PFLEvent *event = [[PFLEvent alloc] init];
    event.eventType = PFLEventTypeDirection;
    event.direction = direction;
    return event;
}

+ (id)exitEvent
{
    PFLEvent *event = [[PFLEvent alloc] init];
    event.eventType = PFLEventTypeExit;
    return event;
}

+ (id)audioStopEventWithAudioID:(NSNumber *)audioID
{
    PFLEvent *event = [[PFLEvent alloc] init];
    event.eventType = PFLEventTypeAudioStop;
    event.audioID = audioID;
    return event;
}

+ (id)multiSampleEventWithAudioID:(NSNumber *)audioID sampleEvents:(NSArray *)sampleEvents
{
    PFLEvent *event = [[PFLEvent alloc] init];
    event.eventType = PFLEventTypeMultiSample;
    event.audioID = audioID;
    event.sampleEvents = sampleEvents;
    return event;
}

+ (id)multiSampleEventWithAudioID:(NSNumber *)audioID multiSample:(PFLMultiSample *)multiSample
{
    NSMutableArray *sampleEvents = [NSMutableArray array];
    for (PFLSample *sample in multiSample.samples) {
        PFLEvent *sampleEvent = [PFLEvent sampleEventWithAudioID:audioID file:sample.file time:sample.time];
        [sampleEvents addObject:sampleEvent];
    }
    return [PFLEvent multiSampleEventWithAudioID:audioID sampleEvents:[NSArray arrayWithArray:sampleEvents]];
}

#pragma mark - PFLCompareObjectsDelegate

- (BOOL)isEqualToObject:(id)object
{
    if ([object isKindOfClass:[PFLEvent class]]) {
        PFLEvent *event = (PFLEvent *)object;
        return [self.audioID isEqualToNumber:event.audioID];
    }
    return NO;
}

@end