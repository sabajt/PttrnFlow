//
//  SynthEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/14/13.
//
//

#import "TickEvent.h"

FOUNDATION_EXPORT NSString *const kDefaultSynthType;

@interface SynthEvent : TickEvent

@property (copy, nonatomic) NSString *midiValue;
@property (copy, nonatomic) NSString *synthType;

- (id)initWithAudioID:(NSNumber *)audioID midiValue:(NSString *)midiValue synthType:(NSString *)synthType;

@end
