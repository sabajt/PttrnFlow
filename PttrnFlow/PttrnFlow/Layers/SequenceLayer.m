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
#import "Tone.h"
#import "TickDispatcher.h"
#import "SGTiledUtils.h"
#import "Arrow.h"
#import "MainSynth.h"
#import "EntryArrow.h"
#import "TickerControl.h"
#import "ColorUtils.h"
#import "PdDispatcher.h"

@interface SequenceLayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (strong, nonatomic) CCTMXTiledMap *tileMap;
@property (assign) GridCoord gridSize;
@property (weak, nonatomic) Tone *pressedTone;
@property (assign) CGPoint gridOrigin;
@property (strong, nonatomic) MainSynth *synth;

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
        
        // setup tick dispatcher with sequence and starting point
        NSMutableDictionary *seq = [self.tileMap objectNamed:kTLDObjectSequence groupNamed:kTLDGroupTickResponders];
        NSMutableDictionary *entry = [self.tileMap objectNamed:kTLDObjectEntry groupNamed:kTLDGroupTickResponders];
        self.synth = [[MainSynth alloc] init];
        
        TickDispatcher *tickDispatcher = [[TickDispatcher alloc] initWithSequence:seq tiledMap:tiledMap synth:self.synth];
        self.tickDispatcher = tickDispatcher;
        [self addChild:self.tickDispatcher];
        
        // tones
        NSMutableArray *tones = [self.tileMap objectsWithName:kTLDObjectTone groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *tone in tones) {
            Tone *toneNode = [[Tone alloc] initWithTone:tone tiledMap:self.tileMap puzzleOrigin:self.position synth:self.synth];
            [self.tickDispatcher registerTickResponder:toneNode];
            [self addChild:toneNode];
        }
        
        // arrows
        NSMutableArray *arrows = [self.tileMap objectsWithName:kTLDObjectArrow groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *arrow in arrows) {
            Arrow *arrowNode = [[Arrow alloc] initWithArrow:arrow tiledMap:self.tileMap puzzleOrigin:self.position synth:self.synth];
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

@end
