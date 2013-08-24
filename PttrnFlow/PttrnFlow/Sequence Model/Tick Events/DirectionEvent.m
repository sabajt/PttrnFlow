//
//  DirectionEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "DirectionEvent.h"

@implementation DirectionEvent

- (id)initWithChannel:(int)channel direction:(NSString *)direction
{
    self = [super initWithChannel:channel isAudioEvent:NO lastLinkedEvent:nil fragments:@[direction]];
    if (self) {
        _direction = direction;
    }
    return self;
}

@end
