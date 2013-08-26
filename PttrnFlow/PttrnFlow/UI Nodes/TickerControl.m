//
//  TickerControl.m
//  PttrnFlow
//
//  Created by John Saba on 6/9/13.
//
//

#import "TickerControl.h"
#import "SpriteUtils.h"
#import "CCSprite+Utils.h"
#import "ColorUtils.h"
#import "CCNode+Touch.h"
#import "TickDispatcher.h"

CGFloat const kTickScrubberDistanceInterval = 40;

static CGFloat const kTickerHeight = 16;
static CGFloat const kTickerWidth = 8;
static CGFloat const kMarkerWidth = 2;
static CGFloat const kMarkerHeight = 16;
static CGFloat const kTickerBarHeight = 2;
static CGFloat const kTickerControlHeight = 50;

@interface TickerControl ()

@property (assign) CGFloat distanceInterval;

@end


@implementation TickerControl

- (id)initWithNumberOfTicks:(int)numberOfTicks distanceInterval:(CGFloat)distanceInterval
{
    self = [super init];
    if (self) {
        if (numberOfTicks < 1) {
            NSLog(@"warning: number of ticks for TickerControl should be > 1");
        }
        self.swallowsTouches = YES;
        self.distanceInterval = distanceInterval;
        _numberOfTicks = numberOfTicks;
        _thumbSprite = [CCSprite rectSpriteWithSize:CGSizeMake(kTickerWidth, kTickerHeight) color:[ColorUtils ticker]];
        
        CCSprite *tickerBar = [CCSprite rectSpriteWithSize:CGSizeMake(numberOfTicks * distanceInterval, kTickerBarHeight) color:[ColorUtils tickerBar]];
        
        self.contentSize = CGSizeMake(tickerBar.contentSize.width, kTickerControlHeight);
        CGFloat tickerBarCenterY = self.contentSize.height / 4;
        tickerBar.position = ccp(self.contentSize.width / 2, tickerBarCenterY);
        
        self.currentIndex = 0;
        [self positionThumb:0];
        
        [self addChild:tickerBar];
        
        for (int i = 0; i < numberOfTicks; i++) {
            CCSprite *marker = [CCSprite rectSpriteWithSize:CGSizeMake(kMarkerWidth, kTickerHeight) color:[ColorUtils tickerBar]];
            marker.position = ccp((i * distanceInterval) + (distanceInterval / 2), tickerBarCenterY + (kTickerBarHeight / 2));
            [self addChild:marker];
        }
        
        [self addChild:_thumbSprite];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAdvancedSequence:) name:kNotificationAdvancedSequence object:nil];
    }
    return self;
}

- (int)nearestIndex:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGFloat index = touchPosition.x / self.distanceInterval;
    return (int)index;
}

- (void)handleTouch:(UITouch *)touch
{
    self.currentIndex = [self nearestIndex:touch];
    if ((self.currentIndex < self.numberOfTicks) && (self.currentIndex >= 0)) {
        [self positionThumb:self.currentIndex];
        [self.delegate tickerMovedToIndex:(self.currentIndex * 4)];
    }
}

- (void)positionThumb:(int)index
{
    self.thumbSprite.position = ccp(index * self.distanceInterval + (self.distanceInterval / 2), (3 * self.contentSize.height) / 4);
}

- (void)handleAdvancedSequence:(NSNotification *)notification
{
    NSNumber *subIndex = notification.userInfo[kKeySequenceIndex];
    self.currentIndex = ([subIndex intValue] / 4);
    NSLog(@"current index: %i", self.currentIndex);
    [self positionThumb:self.currentIndex];
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
//    [self handleTouch:touch];
    
    [super ccTouchEnded:touch withEvent:event];
    [self.delegate tickerControlTouchUp];

}

@end
