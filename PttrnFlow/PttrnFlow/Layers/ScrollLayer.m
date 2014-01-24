//
//  ScrollLayer.m
//  PttrnFlow
//
//  Created by John Saba on 1/24/14.
//
//  Adapted with changes from: http://www.sidebolt.com/simulating-uiscrollview-in-cocos2d/

#import "ScrollLayer.h"

@interface ScrollLayer ()

@property (assign) CGPoint lastFrameTouch;
@property (assign) BOOL isTouching;
@property (assign) CGPoint unfilteredVelocity;
@property (assign) CGPoint velocity;

@end

@implementation ScrollLayer

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [self scheduleUpdate];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}

- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.lastFrameTouch = [self.parent convertTouchToNodeSpace:touch];
	self.isTouching = true;
    return YES;
}

- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint currentTouch = [self.parent convertTouchToNodeSpace:touch];
	self.unfilteredVelocity = ccp(currentTouch.x - self.lastFrameTouch.x, currentTouch.y - self.lastFrameTouch.y);
	self.position = ccpAdd(self.position, self.unfilteredVelocity);
	self.lastFrameTouch = currentTouch;
}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.isTouching = false;
}

- (void)update:(ccTime)dt
{
	if (self.isTouching) {
		const float kFilterAmount = 0.25f;
		CGFloat xVelocity = (self.velocity.x * kFilterAmount) + (self.unfilteredVelocity.x * (1.0f - kFilterAmount));
        CGFloat yVelocity = (self.velocity.y * kFilterAmount) + (self.unfilteredVelocity.y * (1.0f - kFilterAmount));
        self.velocity = ccp(xVelocity, yVelocity);
		self.unfilteredVelocity = CGPointZero;
	}
	else {
        self.velocity = ccpMult(self.velocity, 0.95f);
        self.position = ccpAdd(self.position, self.velocity);
	}
}

@end
