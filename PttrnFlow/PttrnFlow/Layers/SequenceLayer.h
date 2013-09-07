//
//  SequenceLayer.h
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCLayerPanZoom+Utils.h"
#import "TickDispatcher.h"
#import "DragButton.h"

@class PdDispatcher;

@interface SequenceLayer : CCLayerPanZoom <TickDispatcherDelegate, DragItemDelegate>
{
    PdDispatcher *_dispatcher;
    void *_patch;
}

@property (weak, nonatomic) CCSpriteBatchNode *samplesBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *synthBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *othersBatchNode;

+ (CCScene *)sceneWithSequence:(int)sequence;

@end
