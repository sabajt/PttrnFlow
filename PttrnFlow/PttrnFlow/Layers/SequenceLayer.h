//
//  SequenceLayer.h
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GridUtils.h"
#import "PdDispatcher.h"

@class CellObjectLibrary, TickDispatcher, Tone;

@interface SequenceLayer : CCLayer
{
    PdDispatcher *_dispatcher;
    void *_patch;
}

@property (weak, nonatomic) TickDispatcher *tickDispatcher;

+ (CCScene *)sceneWithSequence:(int)sequence;

- (void)playUserSequence;
- (void)playSolutionSequence;

@end
