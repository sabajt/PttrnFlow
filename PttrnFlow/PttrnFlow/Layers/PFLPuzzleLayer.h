//
//  PFLPuzzleLayer.h
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PFLScrollLayer.h"
#import "PFLPuzzleControlsLayer.h"

@class PdDispatcher, PFLAudioResponderStepController, PFLAudioResponderTouchController;

@interface PFLPuzzleLayer : PFLScrollLayer

@property (weak, nonatomic) PFLAudioResponderStepController *sequenceDispatcher;
@property (weak, nonatomic) PFLAudioResponderTouchController *audioTouchDispatcher;

@property (weak, nonatomic) CCSpriteBatchNode *audioObjectsBatchNode;

+ (CCScene *)sceneWithPuzzle:(PFLPuzzle *)puzzle leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

@end
