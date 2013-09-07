//
//  TouchNode.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "TouchNode.h"

@implementation TouchNode

- (id)init
{
    self = [super init];
    if (self) {
        _swallowsTouches = NO;
        _longPressDelay = 0;
        _isReceivingTouch = NO;
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
