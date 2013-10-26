//
//  TouchSprite.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "TouchSprite.h"

@implementation TouchSprite

// override CCSprite's designated initializer for setup
-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];
    if (self) {
        _swallowsTouches = NO;
        _longPressDelay = 0;
        _isReceivingTouch = NO;
        _handleTouches = YES;
    }
    return self;
}

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    return (CGRectContainsPoint(self.boundingBox, touchPosition));
}

- (void)longPress:(ccTime)deltaTime
{
    NSLog(@"long press needs implementation");
}

#pragma mark CCSprite SceneManagement

- (void)onEnter
{
    [super onEnter];
    if (self.handleTouches) {
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:self.swallowsTouches];
    }
}

- (void)onExit
{
    if (self.handleTouches) {
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
	[super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouch:touch]) {
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
    if (![self containsTouch:touch] && (self.longPressDelay > 0)) {
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
