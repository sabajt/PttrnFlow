//
//  ScrollLayer.m
//  PttrnFlow
//
//  Created by John Saba on 1/24/14.
//
//

#import "ScrollLayer.h"

@interface ScrollLayer ()

@property (assign) CGPoint lastFrameTouch;
@property (assign) BOOL isTouching;
@property (assign) CGFloat unfilteredVelocity;
@property (assign) CGFloat velocity;

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
	self.unfilteredVelocity = currentTouch.y - self.lastFrameTouch.y;
	self.position = ccpAdd(self.position, ccp(0, self.unfilteredVelocity));
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
		self.velocity = (self.velocity * kFilterAmount) + (self.unfilteredVelocity * (1.0f - kFilterAmount));
		self.unfilteredVelocity = 0.0f;
	}
	else {
		self.velocity *= 0.95f;
		self.position = ccpAdd(self.position, ccp(0, self.velocity));
	}
}

@end
