//
//  SequenceLayer.m
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SequenceLayer.h"
#import "SequenceControlBarLayer.h"
#import "DataUtils.h"
#import "GameConstants.h"
#import "SimpleAudioEngine.h"
#import "SpriteUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "SGTiledUtils.h"
#import "Tone.h"
#import "SGTiledUtils.h"
#import "Arrow.h"
#import "MainSynth.h"
#import "EntryArrow.h"
#import "TickerControl.h"
#import "ColorUtils.h"
#import "PdDispatcher.h"
#import "Drum.h"
#import "BlockFader.h"
#import "ColorUtils.h"
#import "CCLayer+Positioning.h"
#import "BackgroundLayer.h"
#import "SequenceItemLayer.h"
#import "CCSprite+Utils.h"

@interface SequenceLayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (strong, nonatomic) CCTMXTiledMap *tileMap;
@property (assign) GridCoord gridSize;
@property (weak, nonatomic) Tone *pressedTone;
@property (assign) CGPoint gridOrigin;
@property (strong, nonatomic) MainSynth *synth;
@property (weak, nonatomic) BackgroundLayer *backgroundLayer;
@property (weak, nonatomic) PrimativeCellActor *selectionBox;

@end


@implementation SequenceLayer

+ (CCScene *)sceneWithSequence:(int)sequence
{
    CCScene *scene = [CCScene node];
    
    // contstruct a tiled map from our sequence
    NSString *sequenceName = [NSString stringWithFormat:@"seq%i.tmx", sequence];
    CCTMXTiledMap *tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:sequenceName];
    
    // background
    BackgroundLayer *background = [BackgroundLayer layerWithColor:ccc4(255, 255, 255, 255)];
    [scene addChild:background];
    
    // gameplay layer
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithTiledMap:tiledMap background:background];
    [scene addChild:sequenceLayer];
    
    // hud layer -- top control bar
    static CGFloat controlBarHeight = 80;
    SequenceControlBarLayer *hudLayer = [SequenceControlBarLayer layerWithColor:ccc4BFromccc3B([ColorUtils sequenceHud]) width:sequenceLayer.contentSize.width height:controlBarHeight tickDispatcer:sequenceLayer.tickDispatcher];
    hudLayer.position = ccp(0, sequenceLayer.contentSize.height - hudLayer.contentSize.height);
    [scene addChild:hudLayer z:1];
    
    // hud layer -- right hand item menu
    static CGFloat itemBarWidth = 80;
    SequenceItemLayer *itemLayer = [SequenceItemLayer layerWithColor:ccc4BFromccc3B([ColorUtils sequenceItemBar]) width:itemBarWidth items:@[@(kDragItemArrow), @(kDragItemArrow), @(kDragItemArrow)] dragButtonDelegate:sequenceLayer];
    itemLayer.position = ccp(sequenceLayer.contentSize.width - itemLayer.contentSize.width, sequenceLayer.contentSize.height - hudLayer.contentSize.height - itemLayer.contentSize.height);
    [scene addChild:itemLayer z:1];
    
    return scene;
}

+ (BlockFader *)exitFader:(GridCoord)cell
{
    return [BlockFader blockFaderWithSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) color:[ColorUtils exitFaderBlock] cell:cell duration:kTickInterval];
}

- (id)initWithTiledMap:(CCTMXTiledMap *)tiledMap background:(BackgroundLayer *)backgroundLayer;
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        self.backgroundLayer = backgroundLayer;
        self.synth = [[MainSynth alloc] init];
        self.tileMap = tiledMap;
        self.gridSize = [GridUtils gridCoordFromSize:tiledMap.mapSize];
        
        // CCLayerPanZoom
        self.mode = kCCLayerPanZoomModeSheet;
        self.maxScale = 1;
        self.minScale = 0.3;
        
        // tick dispatcher
        NSMutableDictionary *sequence = [tiledMap objectNamed:kTLDObjectSequence groupNamed:kTLDGroupTickResponders];
        TickDispatcher *tickDispatcher = [[TickDispatcher alloc] initWithSequence:sequence tiledMap:tiledMap synth:self.synth];
        self.tickDispatcher = tickDispatcher;
        self.tickDispatcher.delegate = self;
        [self addChild:self.tickDispatcher];
        
        // tone blocks
        NSMutableArray *tones = [tiledMap objectsWithName:kTLDObjectTone groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *tone in tones) {
            Tone *toneNode = [[Tone alloc] initWithTone:tone tiledMap:tiledMap synth:self.synth];
            [self.tickDispatcher registerTickResponder:toneNode];
            [self addChild:toneNode];
        }
        
        // drum blocks
        NSMutableArray *drums = [tiledMap objectsWithName:kTLDObjectDrum groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *drum in drums) {
            Drum *drumNode = [[Drum alloc] initWithDrum:drum tiledMap:tiledMap synth:self.synth];
            [self.tickDispatcher registerTickResponder:drumNode];
            [self addChild:drumNode];
        }
        
        // arrow blocks
        NSMutableArray *arrows = [tiledMap objectsWithName:kTLDObjectArrow groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *arrow in arrows) {
            Arrow *arrowNode = [[Arrow alloc] initWithArrow:arrow tiledMap:tiledMap synth:self.synth];
            [self.tickDispatcher registerTickResponder:arrowNode];
            [self addChild:arrowNode];
        }
        
        // entry arrow
        NSMutableArray *entries = [tiledMap objectsWithName:kTLDObjectEntry groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *entry in entries) {
            EntryArrow *entryArrow = [[EntryArrow alloc] initWithEntry:entry tiledMap:tiledMap];
            [self addChild:entryArrow];
        }
    }
    return self;
}

- (void)draw
{
    // grid
    ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
    [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:_gridOrigin];
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

#pragma mark - DragButtonDelegate

- (void)dragItemMoved:(kDragItem)itemType touch:(UITouch *)touch
{
    self.selectionBox.visible = YES;
    
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];

    if (self.selectionBox == nil) {
        PrimativeCellActor *selectionBox = [[PrimativeCellActor alloc] initWithRectSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) edgeLength:20 color:[ColorUtils winningBackground] cell:cell touch:NO];
        self.selectionBox = selectionBox;
        [self addChild:selectionBox];
    }
    else {
        [self.selectionBox positionAtCell:cell];
    }
}

- (void)dragItemDropped:(kDragItem)itemType touch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    
    self.selectionBox.visible = NO;
}

#pragma mark - TickDispatcherDelegate

- (void)tickExit:(GridCoord)cell
{
    // create the exit animation -- don't send an event to synth, TickDispatcher handles in this case
    [self addChild:[SequenceLayer exitFader:cell]];
}

- (void)win
{
    [self.backgroundLayer tintToColor:[ColorUtils winningBackground] duration:kTickInterval];
}

#pragma mark - CCStandardTouchDelegate

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super ccTouchesBegan:touches withEvent:event];
    
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
        GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
        
        // create the exit animation and send event to synth
        [self addChild:[SequenceLayer exitFader:cell]];
        [self.synth receiveEvents:@[kExitEvent]];
    }
}

@end
