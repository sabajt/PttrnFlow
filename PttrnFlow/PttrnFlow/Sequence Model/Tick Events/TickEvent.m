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

int const kChannelNone = -1;

#pragma mark - NSString (Fragment)
// Fragments are just strings with known values returned from game objects,
// organized by association with a certain sound or game action.
// The idea is to have a flexible way to construct TickEvents on the fly.

@interface NSString (Fragment)

- (BOOL)isMidiValue;
- (BOOL)isSynthType;

@end

@implementation NSString (Fragment)

- (BOOL)isMidiValue
{
    static int low = 48;
    static int high = 59;

    for (int i = low; i <= high; i++) {
        if ([self isEqualToString:[@(i) stringValue]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSynthType
{
    return [@[@"osc", @"phasor"] hasString:self];
}

- (BOOL)isSampleName
{
    return [[self substringToIndex:@"sample".length - 1] isEqualToString:@"sample"];
}

- (BOOL)isDirection
{
    return [@[@"up", @"down", @"right", @"left"] hasString:self];
}

- (BOOL)isAudioStop
{
    return [self isEqualToString:@"audio_stop"];
}

@end


#pragma mark - TickEventxs
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

- (id)initWithChannel:(int)channel lastLinkedEvent:(TickEvent *)lastLinkedEvent fragments:(NSArray *)fragments
{
    self = [super init];
    if (self) {
        _channel = channel;
        _fragments = fragments;
        _lastLinkedEvent = lastLinkedEvent;
    }
    return self;
}

#pragma mark - Creation Utils

+ (NSArray *)eventsFromFragments:(NSArray *)fragments channel:(int)channel lastLinkedEvents:(NSDictionary *)lastLinkedEvents
{
    // take stock of all possible fragment types
    // for now we do not expect any duplicates but probably will want to handle in the future (fx with cumulative qualities)
    
    NSString *midiValue;
    NSString *synthType;
    NSString *sampleName;
    NSString *direction;
    NSString *audioStop;
    
    for (NSString *f in fragments) {
        if ([f isMidiValue]) {
            midiValue = f;
        }
        if ([f isSynthType]) {
            synthType = f;
        }
        if ([f isSampleName]) {
            sampleName = f;
        }
        if ([f isDirection]) {
            direction = f;
        }
    }
    
    // construct events from fragments
    NSMutableArray *events = [NSMutableArray array];

    // synth events
    if (midiValue != nil) {
        if (synthType == nil) {
            synthType = kDefaultSynthType;
        }
        TickEvent *lastEvent = [lastLinkedEvents objectForKey:@(channel)];
        SynthEvent *synth = [[SynthEvent alloc] initWithChannel:channel lastLinkedEvent:lastEvent midiValue:midiValue synthType:synthType];
        [events addObject:synth];
    }
    
    // sample events
    if (sampleName != nil) {
        [events addObject:[[SampleEvent alloc] initWithChannel:channel sampleName:sampleName]];
    }
    
    // direction events
    if (direction != nil) {
        [events addObject:[[DirectionEvent alloc] initWithChannel:channel direction:direction]];
    }
    
    // audio stop events
    if (audioStop != nil) {
        TickEvent *lastEvent = [lastLinkedEvents objectForKey:@(channel)];
        AudioStopEvent *audioStop = [[AudioStopEvent alloc] initWithChannel:channel lastLinkedEvent:lastEvent fragments:nil];
        [events addObject:audioStop];
    }
    
    return [NSArray arrayWithArray:events];
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