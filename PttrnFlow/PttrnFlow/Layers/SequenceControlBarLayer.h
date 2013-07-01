//
//  SequenceControlBarLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"

@class SequenceControlBarLayer, TickDispatcher;

@interface SequenceControlBarLayer : CCLayerColor

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h tickDispatcer:(TickDispatcher *)tickDispatcher;

@end
