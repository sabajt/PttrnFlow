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

@implementation SequenceHudLayer

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h tickDispatcer:(TickDispatcher *)tickDispatcher tiledMap:(CCTMXTiledMap *)tiledMap
{
    CCLayerColor *layer = [CCLayerColor layerWithColor:color width:w height:h];
    
    // ticker control
    TickerControl *tickerControl = [[TickerControl alloc] initWithNumberOfTicks:tickDispatcher.sequenceLength];
    tickerControl.delegate = tickDispatcher;
    tickerControl.position = ccp(10, 10);
    [layer addChild:tickerControl];

    return layer;
}


@end
