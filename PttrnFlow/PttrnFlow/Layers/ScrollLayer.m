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
	self.isTouching = YES;
    return YES;
}

- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint currentTouch = [self.parent convertTouchToNodeSpace:touch];
	self.unfilteredVelocity = ccp(currentTouch.x - self.lastFrameTouch.x, currentTouch.y - self.lastFrameTouch.y);
    
    static CGFloat minVel = 0.2f;
    CGRect bounds = CGRectMake(0, 0, 320, 568);
    CGPoint min = self.position;
    CGPoint max = ccp(self.position.x + self.contentSize.width, self.position.y + self.contentSize.height);
    
    if (min.x > bounds.origin.x) {
        if (self.unfilteredVelocity.x > minVel) {
            CGFloat distance = min.x - bounds.origin.x;
            CGFloat dx = (1.0f - (1.0f / ((distance * 0.55f / 900.0f) + 1.0))) * 900.f;
            CGFloat normalized = 1.0f - (dx / 20.f);
            self.unfilteredVelocity = ccp(self.unfilteredVelocity.x * normalized, self.unfilteredVelocity.y);
        }
    }
    
	self.position = ccpAdd(self.position, self.unfilteredVelocity);
	self.lastFrameTouch = currentTouch;
}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.isTouching = NO;
}

- (void)update:(ccTime)dt
{
    static CGFloat minVel = 0.3f;
    
	if (self.isTouching) {
        const float kFilterAmount = 0.25f;
		CGFloat xVelocity = (self.velocity.x * kFilterAmount) + (self.unfilteredVelocity.x * (1.0f - kFilterAmount));
        CGFloat yVelocity = (self.velocity.y * kFilterAmount) + (self.unfilteredVelocity.y * (1.0f - kFilterAmount));
        self.velocity = ccp(xVelocity, yVelocity);
		self.unfilteredVelocity = CGPointZero;
        
        // stop after min value
        if (fabsf(self.velocity.x) < minVel) {
            self.velocity = ccp(0, self.velocity.y);
        }
        if (fabsf(self.velocity.y) < minVel) {
            self.velocity = ccp(self.velocity.x, 0);
        }
        return;
	}
    
    BOOL decay = YES;
    CGFloat decayValue = 0.9f;
    
    CGRect bounds = CGRectMake(0, 0, 320, 568);
    CGPoint min = self.position;
    CGPoint max = ccp(self.position.x + self.contentSize.width, self.position.y + self.contentSize.height);
    
    if (min.x > bounds.origin.x) {
        decay = NO;
        if (self.velocity.x > minVel) {
            self.velocity = ccp(self.velocity.x * 0.6f, self.velocity.y);
        }
        else {
            CGFloat distance = min.x - bounds.origin.x;
            CGFloat dx = -((1.0f - (1.0f / ((distance * 0.55f / 900.0f) + 1.0))) * 900.f);
            self.velocity = ccp(dx, self.velocity.y);
        }
    }
    
    if (decay) {
        self.velocity = ccpMult(self.velocity, decayValue);
        
        // stop after min value
        if (fabsf(self.velocity.x) < minVel) {
            self.velocity = ccp(0, self.velocity.y);
        }
        if (fabsf(self.velocity.y) < minVel) {
            self.velocity = ccp(self.velocity.x, 0);
        }
    }
    self.position = ccpAdd(self.position, self.velocity);
}

@end
