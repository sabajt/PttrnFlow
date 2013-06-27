//
//  SequenceLayer.h
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCLayerPanZoom.h"
#import "TickDispatcher.h"

@class PdDispatcher;

@interface SequenceLayer : CCLayerPanZoom <TickDispatcherDelegate>
{
    PdDispatcher *_dispatcher;
    void *_patch;
}

+ (CCScene *)sceneWithSequence:(int)sequence;

@end
