//
//  SequenceLayer.m
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SequenceLayer.h"
#import "SequenceUILayer.h"
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
#import "CCSprite+Utils.h"
#import "Warp.h"
#import "AudioTouchDispatcher.h"
#import "AudioPad.h"
#import "AudioStop.h"
#import "SpeedChange.h"
#import "TextureUtils.h"

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
@property (weak, nonatomic) AudioTouchDispatcher *audioTouchDispatcher;

// TODO: prob remove
@property (strong, nonatomic) NSMutableArray *audioTouchDispatchers;

@property (weak, nonatomic) Tone *pressedTone;
@property (weak, nonatomic) BackgroundLayer *backgroundLayer;
@property (weak, nonatomic) PrimativeCellActor *selectionBox;

@end


@implementation SequenceLayer

#pragma mark - debug methods

// edit debugging options here
- (void)setupDebug
{
    // mute PD
    [MainSynth mute:NO];
    
    // draw grid as defined in our tile map -- does not neccesarily coordinate with gameplay
    // warning: enabling makes many calls to draw cycle -- large maps will lag
    self.shouldDrawGrid = NO;
    
    // layer size reporting:
    // [self.scheduler scheduleSelector:@selector(reportSize:) forTarget:self interval:0.3 paused:NO repeat:kCCRepeatForever delay:0];
    
    // color the background
    // CCSprite *cover = [CCSprite rectSpriteWithSize:self.contentSize edgeLength:30 color:ccBLACK];
    // cover.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    // [self addChild:cover];
}

- (void)reportSize:(ccTime)deltaTime
{
    NSLog(@"\n\n--debug------------------------");
    NSLog(@"seq layer content size: %@", NSStringFromCGSize(self.contentSize));
    NSLog(@"seq layer bounding box: %@", NSStringFromCGRect(self.boundingBox));
    NSLog(@"seq layer position: %@", NSStringFromCGPoint(self.position));
    NSLog(@"seq layer scale: %g", self.scale);
    NSLog(@"--end debug------------------------\n");
}

- (void)draw
{
    // grid
    if (self.shouldDrawGrid) {
        ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
        [GridUtils drawGridWithSize:self.gridSize unitSize:kSizeGridUnit origin:_gridOrigin];
    }
}

#pragma mark - setup

+ (CCScene *)sceneWithSequence:(int)sequence
{    
    CCScene *scene = [CCScene node];
    
    // contstruct a tiled map from our sequence
    NSString *sequenceName = [NSString stringWithFormat:@"seq%i.tmx", sequence];
    CCTMXTiledMap *tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:sequenceName];
    
    // background
//    BackgroundLayer *background = [BackgroundLayer layerWithColor:ccc4BFromccc3B([ColorUtils backgroundGray])];
    BackgroundLayer *background = [BackgroundLayer backgroundLayer];
    [scene addChild:background];
    
    // gameplay layer
    static CGFloat controlBarHeight = 80;
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithSequence:sequence tiledMap:tiledMap background:background topMargin:controlBarHeight];
    [scene addChild:sequenceLayer];
    
    // hud layer -- top control bar
    SequenceUILayer *uiLayer = [[SequenceUILayer alloc] initWithTickDispatcher:sequenceLayer.tickDispatcher dragItems:@[@(kDragItemArrow), @(kDragItemAudioStop), @(kDragItemSpeedChange)] dragItemDelegate:sequenceLayer];
    [scene addChild:uiLayer z:1];
    
    return scene;
}

+ (BlockFader *)exitFader:(GridCoord)cell
{
    return [BlockFader blockFaderWithSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) color:ccGRAY cell:cell duration:kTickInterval];
}

- (id)initWithSequence:(int)sequence tiledMap:(CCTMXTiledMap *)tiledMap background:(BackgroundLayer *)backgroundLayer topMargin:(CGFloat)topMargin;
{
    self = [super init];
    if (self) {
        
        // Initialize Pure Data stuff
        _dispatcher = [[PdDispatcher alloc] init];
        [PdBase setDelegate:_dispatcher];
        _patch = [PdBase openFile:@"pf-main.pd" path:[[NSBundle mainBundle] resourcePath]];
        if (!_patch) {
            NSLog(@"Failed to open patch");
        }
        
        // Sprite sheet batch nodes
        CCSpriteBatchNode *samplesBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeySamplePads stringByAppendingString:@".png"]];
        [self addChild:samplesBatch];
        _samplesBatchNode = samplesBatch;
        
        CCSpriteBatchNode *synthBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeySynthPads stringByAppendingString:@".png"]];
        [self addChild:synthBatch];
        _synthBatchNode = synthBatch;
        
        CCSpriteBatchNode *othersBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyOther stringByAppendingString:@".png"]];
        [self addChild:othersBatch];
        _othersBatchNode = othersBatch;
        
        CCSpriteBatchNode *audioObjectsBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyAudioObjects stringByAppendingString:@".png"]];
        [self addChild:audioObjectsBatch];
        _audioObjectsBatchNode = audioObjectsBatch;

        // Setup
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
        self.maxTouchDistanceToClick = 50;
        
        // tick dispatcher
        TickDispatcher *tickDispatcher = [[TickDispatcher alloc] initWithSequence:sequence tiledMap:tiledMap];
        
        self.tickDispatcher = tickDispatcher;
        self.tickDispatcher.delegate = self;
        [self addChild:self.tickDispatcher];
        
        // audio touch dispatcher
        AudioTouchDispatcher *audioTouchDispatcher = [[AudioTouchDispatcher alloc] init];
        self.audioTouchDispatcher = audioTouchDispatcher;
        [self addChild:self.audioTouchDispatcher];
        
        // create puzzle objects
        [self createPuzzleObjects:tiledMap];

        // find optimal scale and position
        CGRect activeWindow = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height - topMargin);
        self.scale = [self scaleToFitArea:self.absoluteGridSize insideConstraintSize:activeWindow.size];
        self.position = [self positionAtCenterOfGridSized:self.gridSize unitSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) constraintRect:activeWindow];
        
    }
    return self;
}

- (void)createPuzzleObjects:(CCTMXTiledMap *)tiledMap
{
    // audio pads
    NSMutableArray *pads = [tiledMap objectsWithName:kTLDObjectAudioPad groupName:kTLDGroupTickResponders];
    for (NSMutableDictionary *pad in pads) {
        
        GridCoord padChunkOrigin = [tiledMap gridCoordForObject:pad];
        NSNumber *width = [pad objectForKey:@"width"];
        NSNumber *height = [pad objectForKey:@"height"];
        int column = ([width intValue] / kSizeGridUnit);
        int row = ([height intValue] / kSizeGridUnit);
        
        for (int c = 0; c <= column; c++) {
            for (int r = 0; r <= row; r++) {
                GridCoord cell = GridCoordMake(padChunkOrigin.x + c, padChunkOrigin.y + r);
                AudioPad *audioPad = [[AudioPad alloc] initWithCell:cell];
                audioPad.position = [GridUtils relativeMidpointForCell:cell unitSize:kSizeGridUnit];
                [self.tickDispatcher registerTickResponderCellNode:audioPad];
                [self.audioTouchDispatcher addResponder:audioPad];
                [self.audioObjectsBatchNode addChild:audioPad];
            }
        }
    }
    
    // tone blocks
    NSMutableArray *tones = [tiledMap objectsWithName:kTLDObjectTone groupName:kTLDGroupTickResponders];
    for (NSMutableDictionary *tone in tones) {
        
        Tone *toneNode = [[Tone alloc] initWithBatchNode:self.synthBatchNode tone:tone tiledMap:tiledMap];
        [self.tickDispatcher registerTickResponderCellNode:toneNode];
        [self.audioTouchDispatcher addResponder:toneNode];
        [self addChild:toneNode];
    }
    
    // drum blocks
    NSMutableArray *drums = [tiledMap objectsWithName:kTLDObjectDrum groupName:kTLDGroupTickResponders];
    for (NSMutableDictionary *drum in drums) {
        Drum *drumNode = [[Drum alloc] initWithDrum:drum batchNode:self.samplesBatchNode tiledMap:tiledMap];
        [self.tickDispatcher registerTickResponderCellNode:drumNode];
        [self.audioTouchDispatcher addResponder:drumNode];
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
        EntryArrow *entryArrow = [[EntryArrow alloc] initWithBatchNode:self.othersBatchNode entry:entry tiledMap:tiledMap];
        [self addChild:entryArrow];
    }
}

// general rule for legal placement of drag items
- (BOOL)isLegalItemPlacement:(GridCoord)cell itemType:(kDragItem)itemType sender:(id)sender
{
    NSArray *tickResponders = [self.tickDispatcher tickRespondersAtCell:cell];
    
    // a stop item can only be placed on an empty audio pad
    if (itemType == kDragItemAudioStop) {
        if (tickResponders.count == 1) {
            id responder = [tickResponders lastObject];
            return [responder isKindOfClass:[AudioPad class]];
        }
        else {
            return NO;
        }
    }
    
    // otherwise only place on top of a block
    if (tickResponders.count == 0) {
        return NO;
    }
    // can't place on top of another object of same type unless it's the source cell
    else {
        for (id responder in tickResponders) {
            if ([responder isKindOfClass:[sender class]] && ![GridUtils isCell:cell equalToCell:self.draggedItemSourceCell]) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - scene management
// TODO: opening and closing pd patch not matched with onEnter / onExit would cause pd patch to not be opened if
// TODO: leaving scene but keeping sequence layer around then coming back to seq layer

- (void)onEnter
{
    [super onEnter];
    [self setupDebug];
}

- (void)onExit
{    
    [PdBase closeFile:_patch];
    [PdBase setDelegate:nil];

    [super onExit];
}

#pragma mark - DragItemDelegate

- (void)dragItemBegan:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender
{    
    GameNode *gameNode = (GameNode *)sender;
    self.draggedItemSourceCell = gameNode.cell;
    
    if (itemType == kDragItemArrow) {
        self.selectionBox.cell = self.draggedItemSourceCell;
        self.selectionBox.position = [GridUtils relativePositionForGridCoord:self.selectionBox.cell unitSize:kSizeGridUnit];
        self.selectionBox.visible = YES;
    }
}

- (void)dragItemMoved:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    
    if (![GridUtils isCell:cell equalToCell:self.lastDraggedItemCell]) {
        self.lastDraggedItemCell = cell;
        
        // highlight if legal for placement
        BOOL legalPlacement = [self isLegalItemPlacement:cell itemType:itemType sender:sender];
        if (legalPlacement) {
            if (self.selectionBox == nil) {
                PrimativeCellActor *selectionBox = [[PrimativeCellActor alloc] initWithRectSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) edgeLength:20 color:ccYELLOW cell:cell];
                self.selectionBox = selectionBox;
                self.selectionBox.position = [GridUtils relativePositionForGridCoord:self.selectionBox.cell unitSize:kSizeGridUnit];
                [self addChild:selectionBox];
            }
            else {
                self.selectionBox.cell = cell;
                self.selectionBox.position = [GridUtils relativePositionForGridCoord:self.selectionBox.cell unitSize:kSizeGridUnit];
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
        
        // instantiate drag items here -- will just be easiest to hard code each case
        
        if (itemType == kDragItemArrow) {
            Arrow *arrow = [[Arrow alloc] initWithCell:self.lastDraggedItemCell batchNode:self.othersBatchNode facing:kDirectionUp dragItemDelegate:self];
            [self.tickDispatcher registerTickResponderCellNode:arrow];
            [self addChild:arrow];
        }
        else if (itemType == kDragItemWarp) {
            Warp *warp = [[Warp alloc] initWithBatchNode:self.othersBatchNode dragItemDelegate:self cell:self.lastDraggedItemCell];
            [self.tickDispatcher registerTickResponderCellNode:warp];
            [self addChild:warp];
        }
        else if (itemType == kDragItemAudioStop) {
            AudioStop *audioStop = [[AudioStop alloc] initWithBatchNode:self.othersBatchNode cell:self.lastDraggedItemCell dragItemDelegate:self];
            [self.tickDispatcher registerTickResponderCellNode:audioStop];
            [self.audioTouchDispatcher addResponder:audioStop];
            [self addChild:audioStop];
        }
        else if (itemType == kDragItemSpeedChange) {
            SpeedChange *speedChange = [[SpeedChange alloc] initWithBatchNode:self.othersBatchNode Cell:self.lastDraggedItemCell dragItemDelegate:self speed:@"2X"];
            [self.tickDispatcher registerTickResponderCellNode:speedChange];
            [self.audioTouchDispatcher addResponder:speedChange]; // not actually an audio event, but we need to track touches for highlighting
            [self addChild:speedChange];
        }
        
        self.selectionBox.visible = NO;
    }
    
    self.draggedItemSourceCell = [GridUtils gridCoordNone];
    self.lastDraggedItemCell = [GridUtils gridCoordNone];
}

- (CGFloat)dragItemScaleFactor
{
    return self.scale;
}

#pragma mark - TickDispatcherDelegate

- (void)tickExit:(GridCoord)cell
{
    // create the exit animation -- don't send an event to synth, TickDispatcher handles in this case
    [self addChild:[SequenceLayer exitFader:cell]];
}

- (void)win
{
    [self.backgroundLayer tintToColor:ccGREEN duration:kTickInterval];
}

#pragma mark - CCStandardTouchDelegate

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super ccTouchesBegan:touches withEvent:event];

    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
        GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
        
        // create the exit animation and send event to synth if we aren't touching a synth node
        if (![self.tickDispatcher isAnyTickResponderAtCell:cell]) {
            [self addChild:[SequenceLayer exitFader:cell]];
//            [MainSynth receiveEvents:@[kExitEvent]];
        }
    }
}

@end
