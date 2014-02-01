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
    
    // calculate elastic momentum while not touching
    
    CGPoint minPos = self.position;
    CGPoint maxPos = ccp(self.position.x + self.contentSize.width, self.position.y + self.contentSize.height);
    static CGFloat elasticDecay = 0.6f;
    BOOL hasDecayX = YES;
    BOOL hasDecayY = YES;

    if ((minPos.x > self.scrollBounds.origin.x) &&
        self.allowsScrollHorizontal)
    {
        hasDecayX = NO;
        if (self.velocity.x > kClipSpeed) {
            self.velocity = ccp(self.velocity.x * elasticDecay, self.velocity.y);
        }
        else {
            CGFloat distance = minPos.x - self.scrollBounds.origin.x;
            CGFloat dx = -[self elasticPull:distance];
            self.velocity = ccp(dx, self.velocity.y);
        }
    }
    if ((minPos.y > self.scrollBounds.origin.y) &&
        self.allowsScrollVertical)
    {
        hasDecayY = NO;
        if (self.velocity.y > kClipSpeed) {
            self.velocity = ccp(self.velocity.x, self.velocity.y * elasticDecay);
        }
        else {
            CGFloat distance = minPos.y - self.scrollBounds.origin.y;
            CGFloat dy = -[self elasticPull:distance];
            self.velocity = ccp(self.velocity.x, dy);
        }
    }
    if ((maxPos.x < self.scrollBounds.origin.x + self.scrollBounds.size.width) &&
        self.allowsScrollHorizontal)
    {
        hasDecayX = NO;
        if (self.velocity.x < -kClipSpeed) {
            self.velocity = ccp(self.velocity.x * elasticDecay, self.velocity.y);
        }
        else {
            CGFloat distance = (self.scrollBounds.origin.x + self.scrollBounds.size.width) - maxPos.x;
            CGFloat dx = [self elasticPull:distance];
            self.velocity = ccp(dx, self.velocity.y);
        }
    }
    if ((maxPos.y < self.scrollBounds.origin.y + self.scrollBounds.size.height) &&
        self.allowsScrollVertical)
    {
        hasDecayY = NO;
        if (self.velocity.y < -kClipSpeed) {
            self.velocity = ccp(self.velocity.x, self.velocity.y * elasticDecay);
        }
        else {
            CGFloat distance = (self.scrollBounds.origin.y + self.scrollBounds.size.height) - maxPos.y;
            CGFloat dy = [self elasticPull:distance];
            self.velocity = ccp(self.velocity.x, dy);
        }
    }

    static CGFloat decayValue = 0.9f;
    if (hasDecayX) {
        self.velocity = ccp(self.velocity.x * decayValue, self.velocity.y);
    }
    if (hasDecayY) {
        self.velocity = ccp(self.velocity.x, self.velocity.y * decayValue);
    }
    [self clipVelocity];

    self.position = ccpAdd(self.position, self.velocity);
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (self.isTouching) {
        return NO;
    }
	self.lastTouch = [self.parent convertTouchToNodeSpace:touch];
	self.isTouching = YES;
    return YES;
}

- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
    // calculate elastic drag while touching
    
	CGPoint currentTouch = [self.parent convertTouchToNodeSpace:touch];
	self.unfilteredVelocity = ccp(currentTouch.x - self.lastTouch.x, currentTouch.y - self.lastTouch.y);
    self.lastTouch = currentTouch;
    
    CGPoint minPos = self.position;
    CGPoint maxPos = ccp(self.position.x + self.contentSize.width, self.position.y + self.contentSize.height);
    CGFloat strech = 20.0f;
    
    if ((minPos.x > self.scrollBounds.origin.x) &&
        (self.unfilteredVelocity.x > kClipSpeed))
    {
        CGFloat distance = minPos.x - self.scrollBounds.origin.x;
        CGFloat dx = [self elasticPull:distance];
        CGFloat normalized = 1.0f - (dx / strech);
        self.unfilteredVelocity = ccp(self.unfilteredVelocity.x * normalized, self.unfilteredVelocity.y);
    }
    if ((minPos.y > self.scrollBounds.origin.y) &&
        (self.unfilteredVelocity.y > kClipSpeed))
    {
        CGFloat distance = minPos.y - self.scrollBounds.origin.y;
        CGFloat dy = [self elasticPull:distance];
        CGFloat normalized = 1.0f - (dy / strech);
        self.unfilteredVelocity = ccp(self.unfilteredVelocity.x, self.unfilteredVelocity.y * normalized);
    }
    if ((maxPos.x < self.scrollBounds.origin.x + self.scrollBounds.size.width) &&
        (self.unfilteredVelocity.x < -kClipSpeed))
    {
        CGFloat distance = (self.scrollBounds.origin.x + self.scrollBounds.size.width) - maxPos.x;
        CGFloat dx = [self elasticPull:distance];
        CGFloat normalized = 1.0f - (dx / strech);
        self.unfilteredVelocity = ccp(self.unfilteredVelocity.x  * normalized, self.unfilteredVelocity.y);
    }
    if ((maxPos.y < self.scrollBounds.origin.y + self.scrollBounds.size.height) &&
        (self.unfilteredVelocity.y < -kClipSpeed))
    {
        CGFloat distance = (self.scrollBounds.origin.y + self.scrollBounds.size.height) - maxPos.y;
        CGFloat dy = [self elasticPull:distance];
        CGFloat normalized = 1.0f - (dy / strech);
        self.unfilteredVelocity = ccp(self.unfilteredVelocity.x, self.unfilteredVelocity.y  * normalized);
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
