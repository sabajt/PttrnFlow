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

@interface SequenceLayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (strong, nonatomic) CCTMXTiledMap *tileMap;
@property (assign) GridCoord gridSize;
@property (weak, nonatomic) Tone *pressedTone;
@property (assign) CGPoint gridOrigin;
@property (strong, nonatomic) MainSynth *synth;
@property (weak, nonatomic) BackgroundLayer *backgroundLayer;

@end


@implementation SequenceLayer

+ (CCScene *)sceneWithSequence:(int)sequence
{
    CCScene *scene = [CCScene node];
    
    BackgroundLayer *background = [BackgroundLayer layerWithColor:ccc4(255, 255, 255, 255)];
    [scene addChild:background];

    NSString *sequenceName = [NSString stringWithFormat:@"seq%i.tmx", sequence];
    CCTMXTiledMap *tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:sequenceName];
    
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithTiledMap:tiledMap background:background];
    [scene addChild:sequenceLayer];
    
    static CGFloat hudHeight = 80;
    SequenceHudLayer *hudLayer = [SequenceHudLayer layerWithColor:ccc4BFromccc3B([ColorUtils sequenceHud]) width:sequenceLayer.contentSize.width height:hudHeight tickDispatcer:sequenceLayer.tickDispatcher tiledMap:tiledMap];
    hudLayer.position = ccp(0, sequenceLayer.contentSize.height - hudLayer.contentSize.height);
    [scene addChild:hudLayer z:1];

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

# pragma mark - TickDispatcherDelegate

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
