//
//  SampleEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "SampleEvent.h"

@implementation SampleEvent

- (id)initWithChannel:(int)channel sampleName:(NSString *)name
{
    self = [super initWithChannel:channel lastLinkedEvent:nil fragments:@[name]];
    if (self) {
        _fileName = name;
    }
    return self;
}

@end
