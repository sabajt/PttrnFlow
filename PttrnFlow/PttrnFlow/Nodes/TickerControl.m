//
//  TickerControl.m
//  PttrnFlow
//
//  Created by John Saba on 6/9/13.
//
//

#import "TickerControl.h"
#import "SpriteUtils.h"
#import "ColorUtils.h"
#import "CCNode+Touch.h"

static CGFloat const kDistanceInterval = 75;
static CGFloat const kTickerHeight = 50;
static CGFloat const kTickerWidth = 20;
static CGFloat const kMarkerWidth = 10;

@implementation TickerControl

- (id)initWithNumberOfTicks:(int)numberOfTicks
{
    self = [super init];
    if (self) {
        _numberOfTicks = numberOfTicks;
        _thumbSprite = [SpriteUtils rectSprite:CGSizeMake(kTickerWidth, kTickerHeight) color3B:[ColorUtils ticker]];
        
        CCSprite *tickerBar = [SpriteUtils rectSprite:CGSizeMake((numberOfTicks - 1) * kDistanceInterval, kTickerHeight/2) color3B:[ColorUtils tickerBar]];
        
        self.contentSize = CGSizeMake(tickerBar.contentSize.width, kTickerHeight);
        tickerBar.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        
        _thumbSprite.position = ccp(0, self.contentSize.height/2);
        
        [self addChild:tickerBar];
        
        for (int i = 0; i < numberOfTicks; i++) {
            CCSprite *marker = [SpriteUtils rectSprite:CGSizeMake(kMarkerWidth, kTickerHeight) color3B:[ColorUtils tickerBar]];
            marker.position = ccp(i * kDistanceInterval,self.contentSize.height/2);
            [self addChild:marker];
        }
        
        [self addChild:_thumbSprite];
        
    }
    return self;
}

- (void)handleTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
}

#pragma mark CCNode SceneManagement

- (void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouch:touch]) {
        return YES;
    }
    return NO;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self handleTouch:touch];
}

@end