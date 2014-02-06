//
//  TickEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import "TickEvent.h"
#import "NSArray+CompareStrings.h"
#import "SynthEvent.h"
#import "SampleEvent.h"
#import "DirectionEvent.h"
#import "AudioStopEvent.h"
#import "AudioPad.h"
#import "AudioPadEvent.h"
#import "SpeedChangeEvent.h"
#import "NSArray+CompareStrings.h"

NSString *const kChannelNone = @"ChannelNone";

#pragma mark - NSString (Fragment)
// Fragments are just strings with known values returned from game objects,
// organized by association with a certain sound or game action.
// The idea is to have a flexible way to construct TickEvents on the fly.

@implementation NSString (Fragment)

- (BOOL)isSampleName
{
    static NSString *kWav = @"wav";
    if (self.length < (kWav.length + 2)) {
        return NO;
    }
    NSString *extension = [[self componentsSeparatedByString:@"."] lastObject];
    return ([extension isEqualToString:kWav]);
}

- (BOOL)isDirection
{
    return [@[@"up", @"down", @"right", @"left"] hasString:self];
}

- (BOOL)isAudioStop
{
    return [self isEqualToString:@"audio_stop"];
}

- (BOOL)isAudioPad
{
    return [self isEqualToString:@"audio_pad"];
}

- (BOOL)isSpeedChange
{
    return [@[@"1X", @"2X", @"4X"] hasString:self];
}

@end

#pragma mark - NSArray (TickEvents)

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
        return ([event isKindOfClass:[TickEvent class]] && [event isEqualToEvent:targetEvent checkLastLinkedEvent:YES]);
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

#pragma mark - TickEvents
// TickEvents store relevant parameters that we will send in to our PD patches.
// Events may be constructed in different ways:
//  - directly from a pre-constructed datasource (solution sequences are collections of events constructed from a JSON file)
//  - on the fly from a collection of fragments associated with a channel (ticking, touching)
//  - on the fly triggered by some other game logic (for example, receiving 0 events constructs an ExitEvent with no fragments)
// If channel is irrelevant to an event (for example global events like slow down, or any solution seq event), use kChannelNone

@interface TickEvent ()

@property (strong, nonatomic) NSArray *fragments;

@end


@implementation TickEvent

- (id)initWithChannel:(NSString *)channel isAudioEvent:(BOOL)isAudioEvent isLinkedEvent:(BOOL)isLinkedEvent lastLinkedEvent:(TickEvent *)lastLinkedEvent fragments:(NSArray *)fragments
{
    self = [super init];
    if (self) {
        _channel = channel;
        _isAudioEvent = isAudioEvent;
        _lastLinkedEvent = lastLinkedEvent;
        _fragments = fragments;
    }
    return self;
}

- (id)initWithChannel:(NSString *)channel isAudioEvent:(BOOL)isAudioEvent
{
    return [self initWithChannel:channel isAudioEvent:isAudioEvent isLinkedEvent:NO lastLinkedEvent:nil fragments:nil];
}

#pragma mark - Comparison

- (BOOL)isEqualToEvent:(TickEvent *)event checkLastLinkedEvent:(BOOL)checkLastLinkedEvent
{
    // must share same class
    if ([self isKindOfClass:[event class]]) {
        
        // must share all fragments types and count (or none at all)
        BOOL containsNoFragments = (self.fragments == nil) && (event.fragments == nil);
        if (containsNoFragments || [self.fragments hasSameNumberOfSameStrings:event.fragments]) {
            
            // our linked events must share class and same fragments (or none at all)
            if (checkLastLinkedEvent) {
                BOOL containsNoLinkedEvent = (self.lastLinkedEvent == nil) && (event.lastLinkedEvent == nil);

                // recursive call is only ever 1 deep (for comparing to linked event)
                BOOL sameLastLinkedEvent = [self.lastLinkedEvent isEqualToEvent:event.lastLinkedEvent checkLastLinkedEvent:NO];
                if (containsNoLinkedEvent || sameLastLinkedEvent) {
                    return YES;
                }
            }
            // we haven't requested to check last linked (so probably an internal call)
            else {
                return YES;
            }
        }
    }
    return NO;
}

@end