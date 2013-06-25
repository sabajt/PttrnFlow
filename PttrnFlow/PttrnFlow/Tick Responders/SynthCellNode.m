//
//  SynthCellNode.m
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import "SynthCellNode.h"

@implementation SynthCellNode

- (id)initWithSynth:(id<SoundEventReceiver>)synth
{
    self = [super init];
    if (self) {
        self.synth = synth;
    }
    return self;
}

@end
