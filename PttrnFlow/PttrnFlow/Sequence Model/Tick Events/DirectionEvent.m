//
//  DirectionEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "DirectionEvent.h"
#import "GameConstants.h"
#import "NSArray+CompareStrings.h"

@implementation DirectionEvent

- (id)initWithChannel:(NSString *)channel direction:(NSString *)direction
{
    self = [super initAsAudioEvent:NO];
    if (self) {
        _direction = direction;
    }
    return self;
}

#pragma mark - Value checks

+ (BOOL)isDirection:(NSString *)direction
{
    return [@[kDirectionDown, kDirectionLeft, kDirectionRight, kDirectionUp] hasString:direction];
}

@end
