//
//  SampleEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "SampleEvent.h"

@implementation SampleEvent

- (id)initWithChannel:(NSString *)channel sampleName:(NSString *)name
{
    self = [super initWithChannel:channel isAudioEvent:YES isLinkedEvent:YES lastLinkedEvent:nil fragments:@[name]];
    if (self) {
        _fileName = name;
    }
    return self;
}

@end
