//
//  SpeedChangeEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/26/13.
//
//

#import "SpeedChangeEvent.h"

@implementation SpeedChangeEvent

- (id)initWithChannel:(NSString *)channel speed:(NSString *)speed
{
    self = [super initWithChannel:channel isAudioEvent:NO isLinkedEvent:NO lastLinkedEvent:nil fragments:@[speed]];
    if (self) {
        _speed = speed;
    }
    return self;
}

@end
