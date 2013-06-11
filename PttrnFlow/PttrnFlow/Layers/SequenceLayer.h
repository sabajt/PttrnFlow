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


@property (strong, nonatomic) CCTMXTiledMap *tileMap;
@property (strong, nonatomic) CellObjectLibrary *cellObjectLibrary;

@property (weak, nonatomic) TickDispatcher *tickDispatcher;

@property (strong, nonatomic) NSMutableArray *tones;
@property (strong, nonatomic) NSMutableArray *arrows;

@property (assign) GridCoord gridSize;
@property (weak, nonatomic) Tone *pressedTone;

@property (assign) CGPoint gridOrigin;

+ (CCScene *)sceneWithSequence:(int)sequence;
+ (CGPoint)sharedGridOrigin;

- (void)playUserSequence;
- (void)playSolutionSequence;

@end
