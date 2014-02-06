//
//  SynthEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/14/13.
//
//

#import "SynthEvent.h"
#import "NSArray+CompareStrings.h"

NSString *const kDefaultSynthType = @"osc";

@implementation SynthEvent

- (id)initWithChannel:(NSString *)channel lastLinkedEvent:(TickEvent *)lastEvent midiValue:(NSString *)midiValue synthType:(NSString *)synthType
{
    self = [super initWithChannel:channel isAudioEvent:YES isLinkedEvent:YES lastLinkedEvent:lastEvent fragments:@[midiValue, synthType]];
    if (self) {
        NSAssert([SynthEvent isMidiValue:midiValue], @"'%@' is not a valid midi value", midiValue);
        NSAssert([SynthEvent isSynthType:synthType], @"'%@' is not a valid synth type", synthType);
        _midiValue = midiValue;
        _synthType = synthType;
        _lastEvent = lastEvent;
    }
    return self;
}

+ (BOOL)isMidiValue:(NSString *)midiValue
{
    static int low = 48;
    static int high = 59;
    
    for (int i = low; i <= high; i++) {
        if ([midiValue isEqualToString:[@(i) stringValue]]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isSynthType:(NSString *)synthType
{
    return [@[@"osc", @"phasor"] hasString:synthType];
}

@end
