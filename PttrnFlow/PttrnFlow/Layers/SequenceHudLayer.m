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

@implementation SequenceHudLayer

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h tickDispatcer:(TickDispatcher *)tickDispatcher tiledMap:(CCTMXTiledMap *)tiledMap
{
    return [[SequenceHudLayer alloc] initWithColor:color width:w height:h tickDispatcer:tickDispatcher tiledMap:tiledMap];
}

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w  height:(GLfloat)h tickDispatcer:(TickDispatcher *)tickDispatcher tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super initWithColor:color width:w height:h];
    if (self) {        
        // back button
        CCMenuItemSprite *backButton = [[CCMenuItemSprite alloc] initWithNormalSprite:[CCSprite spriteWithSize:CGSizeMake(50, self.contentSize.height) color:ccc3(0, 0, 180) key:@"sequenceHudBackButtonDefault"] selectedSprite:[CCSprite spriteWithSize:CGSizeMake(50, self.contentSize.height) color:ccc3(0, 0, 255) key:@"sequenceHudBackButtonSelected"] disabledSprite:nil target:self selector:@selector(backButtonPressed:)];
        backButton.position = ccp(20, self.contentSize.height/2);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
        
        // ticker control
        TickerControl *tickerControl = [[TickerControl alloc] initWithNumberOfTicks:tickDispatcher.sequenceLength];
        tickerControl.delegate = tickDispatcher;
        tickerControl.position = ccp(100, 10);
        [self addChild:tickerControl];
    }
    return self;
}

- (void)backButtonPressed:(id)sender
{
    [self.delegate sequenceHudBackButtonPressed:self];
}


@end
