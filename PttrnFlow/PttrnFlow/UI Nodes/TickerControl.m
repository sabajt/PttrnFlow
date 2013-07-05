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

static CGFloat const kDistanceInterval = 50;
static CGFloat const kTickerHeight = 16;
static CGFloat const kTickerWidth = 16;
static CGFloat const kMarkerWidth = 6;
static CGFloat const kMarkerHeight = 16;
static CGFloat const kTickerBarHeight = 6;
static CGFloat const kTickerControlHeight = 50;

@implementation TickerControl

- (id)initWithNumberOfTicks:(int)numberOfTicks
{
    self = [super init];
    if (self) {
        if (numberOfTicks < 1) {
            NSLog(@"warning: number of ticks for TickerControl should be > 1");
        }
        self.swallowsTouches = YES;
        _numberOfTicks = numberOfTicks;
        _thumbSprite = [CCSprite rectSpriteWithSize:CGSizeMake(kTickerWidth, kTickerHeight) color:[ColorUtils ticker]];
        
        CCSprite *tickerBar = [CCSprite rectSpriteWithSize:CGSizeMake(numberOfTicks * kDistanceInterval, kTickerBarHeight) color:[ColorUtils tickerBar]];
        
        self.contentSize = CGSizeMake(tickerBar.contentSize.width, kTickerControlHeight);
        CGFloat tickerBarCenterY = self.contentSize.height / 4;
        tickerBar.position = ccp(self.contentSize.width / 2, tickerBarCenterY);
        
        self.currentIndex = 0;
        [self positionThumb:0];
        
        [self addChild:tickerBar];
        
        for (int i = 0; i < numberOfTicks; i++) {
            CCSprite *marker = [CCSprite rectSpriteWithSize:CGSizeMake(kMarkerWidth, kTickerHeight) color:[ColorUtils tickerBar]];
            marker.position = ccp((i * kDistanceInterval) + (kDistanceInterval / 2), tickerBarCenterY + (kTickerBarHeight / 2));
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
    CGFloat index = touchPosition.x / kDistanceInterval;
    return (int)index;
}

- (void)handleTouch:(UITouch *)touch
{
    self.currentIndex = [self nearestIndex:touch];
    if ((self.currentIndex < self.numberOfTicks) && (self.currentIndex >= 0)) {
        [self positionThumb:self.currentIndex];
        [self.delegate tickerMovedToIndex:self.currentIndex];
    }
}

- (void)positionThumb:(int)index
{
    self.thumbSprite.position = ccp(index * kDistanceInterval + (kDistanceInterval / 2), (3 * self.contentSize.height) / 4);
}

- (void)handleAdvancedSequence:(NSNotification *)notification
{
    NSNumber *sequenceIndex = notification.userInfo[kKeySequenceIndex];
    [self positionThumb:[sequenceIndex intValue]];
}

#pragma mark CCNode SceneManagement

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.currentIndex != [self nearestIndex:touch]) {
        [self handleTouch:touch];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self handleTouch:touch];
}

@end
