//
//  TickEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "TickEvent.h"
#import "cocos2d.h"
#import "NSArray+CompareStrings.h"
#import "NSArray+CompareStrings.h"

NSString *const kChannelNone = @"ChannelNone";

@implementation NSArray (TickEvents)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events
{
    // base case: we have succesfully matched all events, or there were never events in either array
    if (self.count == 0 && events.count == 0) {
        return YES;
    }
    
    // pick one of our events to check for a match
    TickEvent *targetEvent = [self firstObject];
    NSUInteger matchIndex = [events indexOfObjectPassingTest:^BOOL(TickEvent *event, NSUInteger idx, BOOL *stop) {
        return ([event isEqualToEvent:targetEvent]);
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
        if ([event isKindOfClass:[TickEvent class]] && event.isAudioEvent) {
            [filtered addObject:event];
        }
    }
    return [NSArray arrayWithArray:filtered];
}

@end

@interface TickEvent ()

@property (strong, nonatomic) NSArray *fragments;

@end

@implementation TickEvent

- (id)initAsAudioEvent:(BOOL)isAudioEvent
{
    self = [super init];
    if (self) {
        _isAudioEvent = isAudioEvent;
    }
    return self;
}

#pragma mark - Subclass hooks

- (BOOL)isEqualToEvent:(TickEvent *)event
{
    CCLOG(@"%@ provides no implementation for %s, returning NO", self, __PRETTY_FUNCTION__);
    return NO;
}

- (NSString *)eventDescription
{
    return [NSString stringWithFormat:@"%@ provides no implementation for %s", self, __PRETTY_FUNCTION__];
}

@end