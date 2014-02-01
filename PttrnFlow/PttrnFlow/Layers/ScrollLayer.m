//
//  ScrollLayer.m
//  PttrnFlow
//
//  Created by John Saba on 1/24/14.
//
//  Adapted with changes from: http://www.sidebolt.com/simulating-uiscrollview-in-cocos2d/

#import "ScrollLayer.h"

static CGFloat const kClipSpeed = 0.25f;

@interface ScrollLayer ()

@property (assign) CGPoint lastTouch;
@property (assign) BOOL isTouching;
@property (assign) CGPoint unfilteredVelocity;
@property (assign) CGPoint velocity;

@end

@implementation ScrollLayer

- (id)init
{
    self = [super init];
    if (self) {
        _allowsScrollHorizontal = YES;
        _allowsScrollVertical = YES;
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

- (CGFloat)elasticPull:(CGFloat)distance
{
    // adapted from http://squareb.wordpress.com/2013/01/06/31/
    // not calculating anything based on screen or container size
    // just using constants for consistent feel
    return (1.0f - (1.0f / ((distance * 0.30f / 900.0f) + 1.0f))) * 900.f;
}

- (void)clipVelocity
{
    // stop after min value
    if (fabsf(self.velocity.x) < kClipSpeed) {
        self.velocity = ccp(0.0f, self.velocity.y);
    }
    if (fabsf(self.velocity.y) < kClipSpeed) {
        self.velocity = ccp(self.velocity.x, 0.0f);
    }
}

- (void)update:(ccTime)dt
{
	if (self.isTouching) {
        const float kFilterAmount = 0.25f;
		CGFloat xVelocity = (self.velocity.x * kFilterAmount) + (self.unfilteredVelocity.x * (1.0f - kFilterAmount));
        CGFloat yVelocity = (self.velocity.y * kFilterAmount) + (self.unfilteredVelocity.y * (1.0f - kFilterAmount));
        self.velocity = ccp(xVelocity, yVelocity);
		self.unfilteredVelocity = CGPointZero;
        [self clipVelocity];
        return;
	}
    
    CGPoint minPos = self.position;
    CGPoint maxPos = ccp(self.position.x + self.contentSize.width, self.position.y + self.contentSize.height);
    
    BOOL decay = YES;

    if ((minPos.x > self.scrollBounds.origin.x) && self.allowsScrollHorizontal) {
        decay = NO;
        if (self.velocity.x > kClipSpeed) {
            self.velocity = ccp(self.velocity.x * 0.6f, self.velocity.y);
        }
        else {
            CGFloat distance = minPos.x - self.scrollBounds.origin.x;
            CGFloat dx = -[self elasticPull:distance];
            self.velocity = ccp(dx, self.velocity.y);
        }
    }
    
    if (decay) {
        static CGFloat decayValue = 0.9f;
        self.velocity = ccpMult(self.velocity, decayValue);
        [self clipVelocity];
    }
    self.position = ccpAdd(self.position, self.velocity);
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.lastTouch = [self.parent convertTouchToNodeSpace:touch];
	self.isTouching = YES;
    return YES;
}

- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint currentTouch = [self.parent convertTouchToNodeSpace:touch];
	self.unfilteredVelocity = ccp(currentTouch.x - self.lastTouch.x, currentTouch.y - self.lastTouch.y);
    self.lastTouch = currentTouch;
    
    CGPoint minPos = self.position;
    CGPoint maxPos = ccp(self.position.x + self.contentSize.width, self.position.y + self.contentSize.height);
    
    if (minPos.x > self.scrollBounds.origin.x) {
        if (self.unfilteredVelocity.x > kClipSpeed) {
            CGFloat distance = minPos.x - self.scrollBounds.origin.x;
            CGFloat dx = [self elasticPull:distance];
            CGFloat normalized = 1.0f - (dx / 20.0f);
            self.unfilteredVelocity = ccp(self.unfilteredVelocity.x * normalized, self.unfilteredVelocity.y);
        }
    }
    
    if (!self.allowsScrollHorizontal) {
        self.unfilteredVelocity = ccp(0.0f, self.unfilteredVelocity.y);
    }
    if (!self.allowsScrollVertical) {
        self.unfilteredVelocity = ccp(self.unfilteredVelocity.x, 0.0f);
    }
    
	self.position = ccpAdd(self.position, self.unfilteredVelocity);
}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.isTouching = NO;
}

@end
