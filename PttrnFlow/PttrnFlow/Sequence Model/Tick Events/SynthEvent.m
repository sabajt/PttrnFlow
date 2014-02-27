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

- (id)initWithAudioID:(NSNumber *)audioID midiValue:(NSString *)midiValue synthType:(NSString *)synthType
{
    self = [super init];
    if (self) {
        self.audioID = audioID;
        NSAssert([SynthEvent isMidiValue:midiValue], @"'%@' is not a valid midi value", midiValue);
        NSAssert([SynthEvent isSynthType:synthType], @"'%@' is not a valid synth type", synthType);
        _midiValue = midiValue;
        _synthType = synthType;
    }
    return self;
}

#pragma mark - Value checks

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

#pragma mark - Subclass hooks

- (BOOL)isEqualToEvent:(TickEvent *)event
{
    if (![event isKindOfClass:self.class]) {
        return NO;
    }
    SynthEvent *synthEvent = (SynthEvent *)event;
    return ([synthEvent.midiValue isEqualToString:self.midiValue] &&
            [synthEvent.synthType isEqualToString:self.synthType]);
}

- (NSString *)eventDescription
{
    return [NSString stringWithFormat:@"%@ : { synth type : %@ } { midi type : %@ } { audio ID : %i }", self, self.synthType, self.midiValue, self.audioID];
}

@end
