//
//  AudioStopEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/22/13.
//
//

#import "AudioStopEvent.h"

@implementation AudioStopEvent

- (id)initWithAudioID:(NSNumber *)audioID
{
    self = [super init];
    if (self) {
        self.audioID = audioID;
    }
    return self;
}

@end
