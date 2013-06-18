//
//  SequenceLayer.m
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SequenceLayer.h"
#import "SequenceHudLayer.h"
#import "DataUtils.h"
#import "GameConstants.h"
#import "SimpleAudioEngine.h"
#import "SpriteUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "SGTiledUtils.h"
#import "CellObjectLibrary.h"
#import "Tone.h"
#import "TickDispatcher.h"
#import "SGTiledUtils.h"
#import "Arrow.h"
#import "MainSynth.h"
#import "EntryArrow.h"
#import "TickerControl.h"
#import "ColorUtils.h"
#import "PdDispatcher.h"

static CGFloat const kPatternDelay = 0.5;

@interface SequenceLayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (strong, nonatomic) CCTMXTiledMap *tileMap;
@property (strong, nonatomic) CellObjectLibrary *cellObjectLibrary;
@property (strong, nonatomic) NSMutableArray *tones;
@property (strong, nonatomic) NSMutableArray *arrows;
@property (assign) GridCoord gridSize;
@property (weak, nonatomic) Tone *pressedTone;
@property (assign) CGPoint gridOrigin;

@end


@implementation SequenceLayer

+ (CCScene *)sceneWithSequence:(int)sequence
{
    CCScene *scene = [CCScene node];
    
    NSString *sequenceName = [NSString stringWithFormat:@"seq%i.tmx", sequence];
    CCTMXTiledMap *tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:sequenceName];
    
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithTiledMap:tiledMap];
    [scene addChild:sequenceLayer];
    
    static CGFloat hudHeight = 80;
    SequenceHudLayer *hudLayer = [SequenceHudLayer layerWithColor:ccc4BFromccc3B([ColorUtils sequenceHud]) width:sequenceLayer.contentSize.width height:hudHeight tickDispatcer:sequenceLayer.tickDispatcher tiledMap:tiledMap];
    hudLayer.position = ccp(0, sequenceLayer.contentSize.height - hudLayer.contentSize.height);
    [scene addChild:hudLayer z:1];

    return scene;
}

- (id)initWithTiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        self.tileMap = tiledMap;
        self.gridSize = [GridUtils gridCoordFromSize:self.tileMap.mapSize];
        
        // pan zoom
        self.mode = kCCLayerPanZoomModeSheet;
        self.maxScale = 1;
        self.minScale = 0.3;
        
        // cell object library
        self.cellObjectLibrary = [[CellObjectLibrary alloc] initWithGridSize:_gridSize];

        // setup tick dispatcher with sequence and starting point
        NSMutableDictionary *seq = [self.tileMap objectNamed:kTLDObjectSequence groupNamed:kTLDGroupTickResponders];
        NSMutableDictionary *entry = [self.tileMap objectNamed:kTLDObjectEntry groupNamed:kTLDGroupTickResponders];
        
        TickDispatcher *tickDispatcher = [[TickDispatcher alloc] initWithSequence:seq entry:entry tiledMap:self.tileMap];
        self.tickDispatcher = tickDispatcher;
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

#pragma mark - scene management

- (void)onEnter
{
    [super onEnter];
    
    _dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:_dispatcher];
    _patch = [PdBase openFile:@"synth.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!_patch) {
        NSLog(@"Failed to open patch");
    }    
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
}
- (void)onExit
{    
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

# pragma mark - CCStandardTouchDelegate

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super ccTouchesBegan:touches withEvent:event];
    
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        
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
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super ccTouchesEnded:touches withEvent:event];
    
    if (self.pressedTone != nil) {
        [self.pressedTone deselectTone];
        self.pressedTone = nil;
    }
}

@end
