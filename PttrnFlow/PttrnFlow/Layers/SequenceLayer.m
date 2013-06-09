//
//  SequenceLayer.m
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SequenceLayer.h"
#import "DataUtils.h"
#import "GameConstants.h"
#import "SimpleAudioEngine.h"
#import "SpriteUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "SGTiledUtils.h"
#import "TextureUtils.h"
#import "CellObjectLibrary.h"
#import "Tone.h"
#import "TickDispatcher.h"
#import "SGTiledUtils.h"
#import "Arrow.h"
#import "MainSynth.h"
#import "EntryArrow.h"

static CGFloat const kPatternDelay = 0.5;


@implementation SequenceLayer

+ (CCScene *)sceneWithSequence:(int)sequence
{
    CCScene *scene = [CCScene node];
    
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithSequence:sequence];
    [scene addChild:sequenceLayer];
    
    return scene;
}

- (id)initWithSequence:(int)sequence
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        
        [TextureUtils loadTextures];
        
        NSString *sequenceName = [NSString stringWithFormat:@"seq%i.tmx", sequence];
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:sequenceName];
        self.gridSize = [GridUtils gridCoordFromSize:self.tileMap.mapSize];
        
        // cell object library
        self.cellObjectLibrary = [[CellObjectLibrary alloc] initWithGridSize:_gridSize];

        // setup tick dispatcher with sequence and starting point
        NSMutableDictionary *seq = [self.tileMap objectNamed:kTLDObjectSequence groupNamed:kTLDGroupTickResponders];
        NSMutableDictionary *entry = [self.tileMap objectNamed:kTLDObjectEntry groupNamed:kTLDGroupTickResponders];
        self.tickDispatcher = [[TickDispatcher alloc] initWithEventSequence:seq entry:entry tiledMap:self.tileMap];
        [self addChild:self.tickDispatcher];

        // tones
        self.tones = [NSMutableArray array];
        NSMutableArray *tones = [self.tileMap objectsWithName:kTLDObjectTone groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *tone in tones) {
            Tone *toneNode = [[Tone alloc] initWithTone:tone tiledMap:self.tileMap puzzleOrigin:self.position];
            [self.tones addObject:toneNode];
            [self.cellObjectLibrary addNode:toneNode cell:toneNode.cell];
            [self.tickDispatcher registerTickResponder:toneNode];
            [self addChild:toneNode];
        }
        
        // arrows
        self.arrows = [NSMutableArray array];
        NSMutableArray *arrows = [self.tileMap objectsWithName:kTLDObjectArrow groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *arrow in arrows) {
            Arrow *arrowNode = [[Arrow alloc] initWithArrow:arrow tiledMap:self.tileMap puzzleOrigin:self.position];
            [self.arrows addObject:arrowNode];
            [self.cellObjectLibrary addNode:arrowNode cell:arrowNode.cell];
            [self.tickDispatcher registerTickResponder:arrowNode];
            [self addChild:arrowNode];
        }
        
        // entry arrow
        EntryArrow *entryArrow = [[EntryArrow alloc] initWithEntry:entry tiledMap:self.tileMap puzzleOrigin:self.position];
        [self addChild:entryArrow];
    }
    return self;
}

+ (CGPoint)sharedGridOrigin
{
    return CGPointMake((1024 - 800)/2, 130);
}

- (void)playUserSequence
{
    [self.tickDispatcher start];
}

- (void)playSolutionSequence
{
    [self.tickDispatcher scheduleSequence];
}

#pragma mark - scene management

- (void)onEnter
{
    [super onEnter];
    
    _dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:_dispatcher];
    _patch = [PdBase openFile:@"synth.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!_patch) {
        NSLog(@"Failed to open patch");
        // handle failure
    }    
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}
- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [PdBase closeFile:_patch];
    [PdBase setDelegate:nil];

    [super onExit];
}

- (void)draw
{
    // grid
    ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
    [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:_gridOrigin];
}

# pragma mark - targeted touch delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];

    for (Tone *tone in self.tones) {
        if (CGRectContainsPoint(tone.boundingBox, touchPosition)) {
            NSString *event = [(id<TickResponder>)tone tick:kBPM];
            [self.tickDispatcher.mainSynth loadEvents:@[event]];
            self.pressedTone = tone;
        }
    }
    for (Arrow *arrow in self.arrows) {
        if (CGRectContainsPoint(arrow.boundingBox, touchPosition)) {
            [arrow rotateClockwise];
            NSString *event = [(id<TickResponder>)arrow tick:kBPM];
            [self.tickDispatcher.mainSynth loadEvents:@[event]];
        }
    }
    
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.pressedTone != nil) {
        [self.pressedTone deselectTone];
        self.pressedTone = nil;
    }
}

@end
