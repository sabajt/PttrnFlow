//
//  TouchSprite.m
//  PttrnFlow
//
//  Created by John Saba on 9/9/13.
//
//

#import "TouchSprite.h"

@implementation TouchSprite

- (id)init
{
    self = [super init];
    if (self) {
        _swallowsTouches = NO;
        _longPressDelay = 0;
        _isReceivingTouch = NO;
        
        // adjust anchor point to match vanilla node
        self.anchorPoint = ccp(0, 0);
    }
    return self;
}

- (void)longPress:(ccTime)deltaTime
{
    NSLog(@"long press needs implementation");
}

#pragma mark CCNode SceneManagement

- (void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:self.swallowsTouches];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self.touchNodeDelegate containsTouch:touch]) {
        self.isReceivingTouch = YES;
        if (self.longPressDelay > 0) {
            [self scheduleOnce:@selector(longPress:) delay:self.longPressDelay];
        }
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![self.touchNodeDelegate containsTouch:touch] && (self.longPressDelay > 0)) {
        [self unschedule:@selector(longPress:)];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.longPressDelay > 0) {
        [self unschedule:@selector(longPress:)];
    }
    self.isReceivingTouch = NO;
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.longPressDelay > 0) {
        [self unschedule:@selector(longPress:)];
    }
    self.isReceivingTouch = NO;
}

@end
