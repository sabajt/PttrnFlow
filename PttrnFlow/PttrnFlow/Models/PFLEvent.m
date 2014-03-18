//
//  PFLEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "NSArray+CompareStrings.h"
#import "NSArray+PFLCompareObjects.h"
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

+ (NSArray *)puzzleSolutionEvents:(PFLPuzzle *)puzzle
{
    NSMutableArray *solutionEvents = [NSMutableArray array];
    NSArray *solution = puzzle.solution;
    
    for (NSArray *s in solution) {
        NSMutableArray *events = [NSMutableArray array];
        for (NSNumber *audioID in s) {
            id object = puzzle.audio[[audioID integerValue]];
            id event;
            if ([object isKindOfClass:[PFLMultiSample class]]) {
                event = [PFLEvent multiSampleEventWithAudioID:audioID multiSample:(PFLMultiSample *)object];
            }
            [events addObject:event];
        }
        [solutionEvents addObject:events];
    }
    return solutionEvents;
}

+ (NSArray *)puzzleSetSolutionEvents:(PFLPuzzleSet *)puzzleSet
{
    NSInteger i = 0;
    
    for (PFLPuzzle *puzzle in puzzleSet.puzzles) {
        NSArray *keyframes = puzzleSet.keyframeSets[i];
        
        for (PFLKeyframe *keyframe in keyframes) {
            
        }
        i++;
    }
}

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