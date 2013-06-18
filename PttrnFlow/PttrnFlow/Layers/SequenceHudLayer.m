//
//  SequenceHudLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "SequenceHudLayer.h"
#import "TickerControl.h"
#import "TickDispatcher.h"
#import "CCSprite+Utils.h"

@interface SequenceHudLayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;

@end


@implementation SequenceHudLayer

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h tickDispatcer:(TickDispatcher *)tickDispatcher tiledMap:(CCTMXTiledMap *)tiledMap
{
    return [[SequenceHudLayer alloc] initWithColor:color width:w height:h tickDispatcer:tickDispatcher tiledMap:tiledMap];
}

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w  height:(GLfloat)h tickDispatcer:(TickDispatcher *)tickDispatcher tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super initWithColor:color width:w height:h];
    if (self) {
        CGFloat yMid = self.contentSize.height/2;
        _tickDispatcher = tickDispatcher;
        CGSize buttonSize = CGSizeMake(self.contentSize.height, self.contentSize.height);
        
        // back button
        CCMenuItemSprite *backButton = [[CCMenuItemSprite alloc] initWithNormalSprite:[CCSprite spriteWithSize:buttonSize color:ccc3(180, 0, 0) key:@"sequenceHudBackButtonDefault"] selectedSprite:[CCSprite spriteWithSize:buttonSize color:ccc3(255, 0, 0) key:@"sequenceHudBackButtonSelected"] disabledSprite:nil target:self selector:@selector(backButtonPressed:)];
        backButton.position = ccp(buttonSize.width/2, yMid);
        
        // match sequence button
        CCMenuItemSprite *matchButton = [[CCMenuItemSprite alloc] initWithNormalSprite:[CCSprite spriteWithSize:buttonSize color:ccc3(0, 180, 0) key:@"sequenceHudMatchButtonDefault"] selectedSprite:[CCSprite spriteWithSize:buttonSize color:ccc3(0, 255, 0) key:@"sequenceHudMatchButtonSelected"] disabledSprite:nil target:self selector:@selector(matchButtonPressed:)];
        matchButton.position = ccp(backButton.position.x + backButton.contentSize.width, yMid);
        
        // run button
        CCMenuItemSprite *runButton = [[CCMenuItemSprite alloc] initWithNormalSprite:[CCSprite spriteWithSize:buttonSize color:ccc3(180, 180, 0) key:@"sequenceHudRunButtonDefault"] selectedSprite:[CCSprite spriteWithSize:buttonSize color:ccc3(255, 255, 0) key:@"sequenceHudRunButtonSelected"] disabledSprite:nil target:self selector:@selector(runButtonPressed:)];
        runButton.position = ccp(self.contentSize.width - buttonSize.width/2, yMid);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:backButton, matchButton, runButton, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
        
        // ticker control
        TickerControl *tickerControl = [[TickerControl alloc] initWithNumberOfTicks:tickDispatcher.sequenceLength];
        tickerControl.delegate = tickDispatcher;
        tickerControl.position = ccp(matchButton.position.x + matchButton.contentSize.width, (self.contentSize.height - tickerControl.contentSize.height)/2);
        [self addChild:tickerControl];
    }
    return self;
}

- (void)backButtonPressed:(id)sender
{
    [[CCDirector sharedDirector] popScene];
}

- (void)matchButtonPressed:(id)sender
{
    [self.tickDispatcher scheduleSequence];
}

- (void)runButtonPressed:(id)sender
{
    [self.tickDispatcher start];
}


@end
