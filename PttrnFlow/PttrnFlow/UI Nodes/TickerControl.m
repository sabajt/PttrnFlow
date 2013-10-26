//
//  TickerControl.m
//  PttrnFlow
//
//  Created by John Saba on 10/26/13.
//
//

#import "TickerControl.h"
#import "SpriteUtils.h"
#import "CCSprite+Utils.h"
#import "ColorUtils.h"
#import "TickDispatcher.h"

@interface TickerControl ()

@property (weak, nonatomic) CCSprite *thumbSprite;
@property (assign) CGSize unitSize;
@property (assign) BOOL isReceivingTouches;

@end

@implementation TickerControl

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName steps:(int)steps unitSize:(CGSize)unitSize
{
    self = [super initWithSpriteFrameName:spriteFrameName];
    if (self) {
        if (steps < 1) {
            NSLog(@"warning: steps TickerControl should be > 1");
        }

        self.swallowsTouches = YES;
        self.contentSize = CGSizeMake(unitSize.width * steps, unitSize.height);
        
        _steps = steps;
        _unitSize = unitSize;
        _currentIndex = 0;

        _thumbSprite = [CCSprite spriteWithSpriteFrameName:@"tickdot_on.png"];
        self.thumbSprite.visible = NO;
        [self addChild:self.thumbSprite];

        for (int i = 0; i < steps; i++) {
            CCSprite *spr = [CCSprite spriteWithSpriteFrameName:@"tickdot_off.png"];
            spr.position = ccp((i * self.unitSize.width + (self.unitSize.width / 2)), self.unitSize.height / 2);
            [self addChild:spr];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAdvancedSequence:) name:kNotificationAdvancedSequence object:nil];

    }
    return self;
}

- (int)nearestIndex:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGFloat index = touchPosition.x / self.unitSize.width;
    return (int)index;
}

- (void)handleTouch:(UITouch *)touch
{
    self.currentIndex = [self nearestIndex:touch];
    if ((self.currentIndex < self.steps) && (self.currentIndex >= 0)) {
        [self positionThumb:self.currentIndex];
        [self.tickerControlDelegate tickerMovedToIndex:(self.currentIndex * 4)];
    }
}

- (void)positionThumb:(int)index
{
    self.thumbSprite.visible = YES;
    self.thumbSprite.position = ccp((index * self.unitSize.width) + self.unitSize.width / 2, self.unitSize.height / 2);
}

- (void)handleAdvancedSequence:(NSNotification *)notification
{
    NSNumber *subIndex = notification.userInfo[kKeySequenceIndex];
    self.currentIndex = ([subIndex intValue] / 4);
    [self positionThumb:self.currentIndex];
}

#pragma mark -

- (BOOL)shouldStealTouch
{
    return self.isReceivingTouch;
}

#pragma mark - TouchNodeDelegate

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect localBox = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    return CGRectContainsPoint(localBox, touchPosition);
}

#pragma mark CCNode SceneManagement

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        self.isReceivingTouch = YES;
        [self handleTouch:touch];
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchMoved:touch withEvent:event];

    if (self.currentIndex != [self nearestIndex:touch]) {
        [self handleTouch:touch];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    self.isReceivingTouch = NO;
    [self.tickerControlDelegate tickerControlTouchUp];
}

@end
