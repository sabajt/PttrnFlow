//
//  SequenceHudLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"

@class SequenceHudLayer, TickDispatcher;

@protocol SequenceHudDelegate <NSObject>

- (void)sequenceHudBackButtonPressed:(SequenceHudLayer *)hudLayer;
- (void)sequenceHudMatchButtonPressed:(SequenceHudLayer *)hudLayer;

@end


@interface SequenceHudLayer : CCLayerColor

@property (weak, nonatomic) id<SequenceHudDelegate> delegate;

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h tickDispatcer:(TickDispatcher *)tickDispatcher tiledMap:(CCTMXTiledMap *)tiledMap;

@end
