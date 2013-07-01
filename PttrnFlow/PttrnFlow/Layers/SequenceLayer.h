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
#import "DragButton.h"

@class PdDispatcher;

@interface SequenceLayer : CCLayerPanZoom <TickDispatcherDelegate, DragButtonDelegate>
{
    PdDispatcher *_dispatcher;
    void *_patch;
}

+ (CCScene *)sceneWithSequence:(int)sequence;

@end
