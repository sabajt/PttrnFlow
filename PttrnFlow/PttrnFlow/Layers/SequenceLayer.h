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

@class PdDispatcher;

@interface SequenceLayer : PanLayer <TickDispatcherDelegate>
{
    PdDispatcher *_dispatcher;
    void *_patch;
}

@property (weak, nonatomic) CCSpriteBatchNode *samplesBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *synthBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *othersBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *audioObjectsBatchNode;

@property (strong, nonatomic) NSArray *areaCells;

+ (CCScene *)sceneWithSequence:(int)sequence;

@end
