//
//  TickEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "TickEvent.h"
#import "NSArray+CompareStrings.h"
#import "NSArray+CompareStrings.h"

NSString *const kChannelNone = @"ChannelNone";

@implementation NSArray (TickEvents)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events
{
    // base case: we have succesfully matched every occurance of every string
    if (self.count == 0 && events.count == 0) {
        return YES;
    }
    
    // pick one of our events to check
    TickEvent *targetEvent = [self lastObject];
    if (![targetEvent isKindOfClass:[TickEvent class]]) {
        return NO;
    }
    
    // find index of matching event if there is one
    NSUInteger targetIndex = [events indexOfObjectPassingTest:^BOOL(TickEvent *event, NSUInteger idx, BOOL *stop) {
        return ([event isKindOfClass:[TickEvent class]] && [event isEqualToEvent:targetEvent]);
    }];
    
    // no match
    if (targetIndex == NSNotFound) {
        return NO;
    }
    
    // if we've found a match, remove matches in mutable copies of both arrays
    NSMutableArray *mutableSelf = [NSMutableArray arrayWithArray:self];
    NSMutableArray *mutableEvents = [NSMutableArray arrayWithArray:events];
    [mutableSelf removeObjectAtIndex:0];
    [mutableEvents removeObjectAtIndex:targetIndex];
    
    // recursive call to new, shortened arrays
    return [mutableSelf hasSameNumberOfSameEvents:mutableEvents];
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

#pragma mark - Comparison

- (BOOL)isEqualToEvent:(TickEvent *)event
{
    // needs implementation
    return NO;
}

@end