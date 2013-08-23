//
//  SynthEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/14/13.
//
//

#import "SynthEvent.h"

NSString *const kDefaultSynthType = @"osc";

@implementation SynthEvent

- (id)initWithChannel:(int)channel lastLinkedEvent:(TickEvent *)lastEvent midiValue:(NSString *)midiValue synthType:(NSString *)synthType
{
    self = [super initWithChannel:channel lastLinkedEvent:lastEvent fragments:@[midiValue, synthType]];
    if (self) {
        _midiValue = midiValue;
        _synthType = synthType;
        _lastEvent = lastEvent;
    }
    return self;
}

@end
