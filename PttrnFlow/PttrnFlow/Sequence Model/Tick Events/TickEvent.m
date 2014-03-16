//
//  TickEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "cocos2d.h"
#import "MultiSampleEvent.h"
#import "NSArray+CompareStrings.h"
#import "TickEvent.h"
#import "PFLPuzzle.h"

NSString *const kChannelNone = @"ChannelNone";

@implementation NSArray (TickEvents)

// TODO: this could be abstracted out to a catagory with 'equals object' protocol
- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events
{
    if (self.count == 0) {
        // we have succesfully matched all events, or there were never events in either array
        if (events.count == 0) {
            return YES;
        }
        // not the same number of events
        return NO;
    }
    
    // pick one of our events to check for a match
    TickEvent *targetEvent = [self firstObject];
    NSUInteger matchIndex = [events indexOfObjectPassingTest:^BOOL(TickEvent *event, NSUInteger idx, BOOL *stop) {
        return ([event.audioID isEqualToNumber:targetEvent.audioID]);
    }];
    
    // no match
    if (matchIndex == NSNotFound) {
        return NO;
    }
    
    // if we've found a match, remove matches copies of both arrays
    NSMutableArray *mutableSelf = [NSMutableArray arrayWithArray:self];
    NSMutableArray *mutableTargets = [NSMutableArray arrayWithArray:events];
    [mutableSelf removeObjectAtIndex:0];
    [mutableTargets removeObjectAtIndex:matchIndex];
    
    // recursive call to new, shortened arrays
    return [[NSArray arrayWithArray:mutableSelf] hasSameNumberOfSameEvents:[NSArray arrayWithArray:mutableTargets]];
}

- (NSArray *)audioEvents
{
    NSMutableArray *filtered = [NSMutableArray array];
    for (TickEvent *event in self) {
        if ([event isKindOfClass:[TickEvent class]] && event.audioID) {
            [filtered addObject:event];
        }
    }
    return [NSArray arrayWithArray:filtered];
}

@end

@interface TickEvent ()

@end

@implementation TickEvent

+ (NSArray *)puzzleSolutionEvents:(PFLPuzzle *)puzzle
{
    NSMutableArray *solutionEvents = [NSMutableArray array];
    NSArray *solution = puzzle.solution;
    
    for (NSDictionary *s in solution) {
        NSMutableArray *events = [NSMutableArray array];
        
        for (NSNumber *audioID in s) {
            NSDictionary *data = puzzle.audio[[audioID integerValue]];
            NSDictionary *samples = data[kPFLPuzzleSamples];
            
            if (samples) {
                NSMutableDictionary *multiSampleData = [NSMutableDictionary dictionary];
                for (NSDictionary *unit in samples) {
                    multiSampleData[unit[kPFLPuzzleTime]] = unit[kPFLPuzzleFile];
                }
                MultiSampleEvent *event = [[MultiSampleEvent alloc] initWithAudioID:audioID timedSamplesData:multiSampleData];
                [events addObject:event];
            }
        }
        [solutionEvents addObject:events];
    }
    return solutionEvents;
}

#pragma mark - Subclass hooks

- (NSString *)eventDescription
{
    return [NSString stringWithFormat:@"%@ provides no implementation for %s", self, __PRETTY_FUNCTION__];
}

@end