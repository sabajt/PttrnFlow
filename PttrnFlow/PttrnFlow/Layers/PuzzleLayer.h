//
//  PuzzleLayer.h
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PFLScrollLayer.h"
#import "SequenceControlsLayer.h"

@class PdDispatcher, SequenceDispatcher, AudioTouchDispatcher;

@interface PuzzleLayer : PFLScrollLayer
{
    PdDispatcher *_dispatcher;
    void *_patch;
}

@property (weak, nonatomic) SequenceDispatcher *sequenceDispatcher;
@property (weak, nonatomic) AudioTouchDispatcher *audioTouchDispatcher;

@property (weak, nonatomic) CCSpriteBatchNode *samplesBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *synthBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *othersBatchNode;
@property (weak, nonatomic) CCSpriteBatchNode *audioObjectsBatchNode;

+ (CCScene *)sceneWithPuzzle:(PFLPuzzle *)puzzle leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

@end
