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

@property (assign) GridCoord gridSize;
@property (assign) CGSize absoluteGridSize;
@property (assign) CGPoint gridOrigin; // TODO: using grid origin except for drawing debug grid?
@property (assign) GridCoord lastDraggedItemCell;
@property (assign) GridCoord draggedItemSourceCell;
@property (assign) BOOL shouldDrawGrid; // debugging

@property (strong, nonatomic) CCTMXTiledMap *tileMap;
@property (strong, nonatomic) MainSynth *synth;

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (weak, nonatomic) Tone *pressedTone;
@property (weak, nonatomic) BackgroundLayer *backgroundLayer;
@property (weak, nonatomic) PrimativeCellActor *selectionBox;

@end


@implementation SequenceLayer {}

#pragma mark - debug methods

// edit debugging options here
- (void)setupDebug
{
    // mute PD
    [self.synth mute:YES];
    
    // draw grid as defined in our tile map -- does not neccesarily coordinate with gameplay
    self.shouldDrawGrid = YES;
    
    // layer size reporting:
    // [self.scheduler scheduleSelector:@selector(reportSize:) forTarget:self interval:0.3 paused:NO repeat:kCCRepeatForever delay:0];
    
    // color the background
    // CCSprite *cover = [CCSprite rectSpriteWithSize:self.contentSize edgeLength:30 color:ccBLACK];
    // cover.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    // [self addChild:cover];
}

- (void)reportSize:(ccTime)deltaTime
{
    if (self.boundingBox.origin.x > -10 && self.boundingBox.origin.y > -10 && self.boundingBox.origin.x < 10 && self.boundingBox.origin.y < 10)
    {
        NSLog(@"\n\n--debug------------------------");
        NSLog(@"seq layer content size: %@", NSStringFromCGSize(self.contentSize));
        NSLog(@"seq layer bounding box: %@", NSStringFromCGRect(self.boundingBox));
        NSLog(@"seq layer position: %@", NSStringFromCGPoint(self.position));
        NSLog(@"seq layer scale: %g", self.scale);
        NSLog(@"--end debug------------------------\n");
    }
}

- (void)draw
{
    // grid
    ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
    [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:_gridOrigin];
}

#pragma mark - setup

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
    static CGFloat controlBarHeight = 80;
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithTiledMap:tiledMap background:background topMargin:controlBarHeight];
    [scene addChild:sequenceLayer];
    
    // hud layer -- top control bar
    SequenceControlBarLayer *hudLayer = [SequenceControlBarLayer layerWithColor:ccc4BFromccc3B([ColorUtils sequenceHud]) width:sequenceLayer.contentSize.width height:controlBarHeight tickDispatcer:sequenceLayer.tickDispatcher];
    hudLayer.position = ccp(0, sequenceLayer.contentSize.height - hudLayer.contentSize.height);
    [scene addChild:hudLayer z:1];
    
    // hud layer -- right hand item menu
    static CGFloat itemBarWidth = 80;
    SequenceItemLayer *itemLayer = [SequenceItemLayer layerWithColor:ccc4BFromccc3B([ColorUtils sequenceItemBar]) width:itemBarWidth items:@[@(kDragItemArrow)] dragButtonDelegate:sequenceLayer];
    itemLayer.position = ccp(sequenceLayer.contentSize.width - itemLayer.contentSize.width, sequenceLayer.contentSize.height - hudLayer.contentSize.height - itemLayer.contentSize.height);
    [scene addChild:itemLayer z:1];
    
    return scene;
}

+ (BlockFader *)exitFader:(GridCoord)cell
{
    return [BlockFader blockFaderWithSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) color:[ColorUtils exitFaderBlock] cell:cell duration:kTickInterval];
}

- (id)initWithTiledMap:(CCTMXTiledMap *)tiledMap background:(BackgroundLayer *)backgroundLayer topMargin:(CGFloat)topMargin;
{
    self = [super init];
    if (self) {        
        self.isTouchEnabled = YES;
        self.backgroundLayer = backgroundLayer;
        self.synth = [[MainSynth alloc] init];
        self.tileMap = tiledMap;
        self.gridSize = [GridUtils gridCoordFromSize:tiledMap.mapSize];
        self.absoluteGridSize = CGSizeMake(self.gridSize.x * kSizeGridUnit, self.gridSize.y * kSizeGridUnit);
        self.draggedItemSourceCell = [GridUtils gridCoordNone];
        
        // CCLayerPanZoom
        self.mode = kCCLayerPanZoomModeSheet;
        self.maxScale = 1;
        self.minScale = .3;
        
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
        
//        // arrow blocks
//        NSMutableArray *arrows = [tiledMap objectsWithName:kTLDObjectArrow groupName:kTLDGroupTickResponders];
//        for (NSMutableDictionary *arrow in arrows) {
//            Arrow *arrowNode = [[Arrow alloc] initWithArrow:arrow tiledMap:tiledMap synth:self.synth];
//            [self.tickDispatcher registerTickResponder:arrowNode];
//            [self addChild:arrowNode];
//        }
        
        // entry arrow
        NSMutableArray *entries = [tiledMap objectsWithName:kTLDObjectEntry groupName:kTLDGroupTickResponders];
        for (NSMutableDictionary *entry in entries) {
            EntryArrow *entryArrow = [[EntryArrow alloc] initWithEntry:entry tiledMap:tiledMap];
            [self addChild:entryArrow];
        }

        // find optimal scale and position
        CGRect activeWindow = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height - topMargin);
        self.scale = [self scaleToFitArea:self.absoluteGridSize insideConstraintSize:activeWindow.size];
        self.position = [self positionAtCenterOfGridSized:self.gridSize unitSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) constraintRect:activeWindow];
        
        [self setupDebug];
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

#pragma mark - DragButtonDelegate

- (void)dragItemBegan:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender
{    
    CellNode *cellNode = (CellNode *)sender;
    self.draggedItemSourceCell = cellNode.cell;
    
    if (itemType == kDragItemArrow) {
        [self.selectionBox positionAtCell:self.draggedItemSourceCell];
        self.selectionBox.visible = YES;
    }
}

- (void)dragItemMoved:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    
    if (![GridUtils isCell:cell equalToCell:self.lastDraggedItemCell]) {
        self.lastDraggedItemCell = cell;
        
        NSArray *tickResponders = [self.tickDispatcher tickRespondersAtCell:cell];
        BOOL legalPlacement = YES;
        
        // check arrows
        if (itemType == kDragItemArrow) {
            
            // only place on top of a block
            if (tickResponders.count == 0) {
                legalPlacement = NO;
            }
            else {
                for (id responder in tickResponders) {
                    
                    // can't place on top of another arrow unless it's the source cell
                    if ([responder isKindOfClass:[Arrow class]] && ![GridUtils isCell:cell equalToCell:self.draggedItemSourceCell]) {
                        legalPlacement = NO;
                    }
                }
            }
        }
        
        // check other types...
        else {
            legalPlacement = NO;
        }
        
        // highlight if legal for placement
        if (legalPlacement) {
            if (self.selectionBox == nil) {
                PrimativeCellActor *selectionBox = [[PrimativeCellActor alloc] initWithRectSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) edgeLength:20 color:[ColorUtils winningBackground] cell:cell touch:NO];
                self.selectionBox = selectionBox;
                [self addChild:selectionBox];
            }
            else {
                [self.selectionBox positionAtCell:cell];
            }
            self.selectionBox.visible = YES;
        }
        else {
            self.selectionBox.visible = NO;
        }
    }
}

- (void)dragItemDropped:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender
{    
    if (self.selectionBox.visible) {
        
        if (itemType == kDragItemArrow) {
            Arrow *arrow = [[Arrow alloc] initWithSynth:self.synth cell:self.lastDraggedItemCell facing:kDirectionUp dragItemDelegate:self];
            [self.tickDispatcher registerTickResponder:arrow];
            [self addChild:arrow];
        }
        
        self.selectionBox.visible = NO;
    }
    
    self.draggedItemSourceCell = [GridUtils gridCoordNone];
    self.lastDraggedItemCell = [GridUtils gridCoordNone];
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
