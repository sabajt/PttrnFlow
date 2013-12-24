//
//  SequenceLayer.h
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PanLayer.h"
#import "TickDispatcher.h"
#import "DragButton.h"

@class PdDispatcher;

@interface SequenceLayer : PanLayer <TickDispatcherDelegate, DragItemDelegate>
{
    PdDispatcher *_dispatcher;
    void *_patch;
}

@property (weak, nonatomic) CCSpriteBatchNode *samplesBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *synthBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *othersBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *audioObjectsBatchNode;

// set of active puzzle coordinates represented as strings: (1, 3) -> @"13"
@property (strong, nonatomic) NSSet *area;

+ (CCScene *)sceneWithSequence:(int)sequence;

@end
