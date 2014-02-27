//
//  AudioStopEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/22/13.
//
//

#import "TickEvent.h"

@interface AudioStopEvent : TickEvent

- (id)initWithAudioID:(NSNumber *)audioID;

@end
