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
#import "PuzzleUtils.h"

@interface SequenceLayer ()

@property (assign) GridCoord gridSize;
@property (assign) CGSize absoluteGridSize;
@property (assign) CGPoint gridOrigin; // TODO: using grid origin except for drawing debug grid?
@property (assign) GridCoord lastDraggedItemCell;
@property (assign) GridCoord draggedItemSourceCell;
@property (assign) BOOL shouldDrawGrid; // debugging

@property (strong, nonatomic) MainSynth *synth;

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (weak, nonatomic) AudioTouchDispatcher *audioTouchDispatcher;

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
    BackgroundLayer *background = [BackgroundLayer backgroundLayer];
    [scene addChild:background];
    
    // gameplay layer
    static CGFloat controlBarHeight = 80;
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithSequence:sequence tiledMap:tiledMap background:background topMargin:controlBarHeight];
    [scene addChild:sequenceLayer];
    
    // hud layer -- controls / item menu
    SequenceUILayer *uiLayer = [[SequenceUILayer alloc] initWithPuzzle:sequence tickDispatcher:sequenceLayer.tickDispatcher dragItemDelegate:sequenceLayer];
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
        
        NSArray *cells = [PuzzleUtils puzzleArea:sequence];
        self.gridSize = [GridUtils maxCoord:cells];
        
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
        self.area = [self createPuzzleArea:sequence];
        [self createPuzzleBorder:sequence];
        [self createPuzzleObjects:sequence];
        
        // find optimal scale and position
        CGRect activeWindow = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height - topMargin);
        self.scale = [self scaleToFitArea:self.absoluteGridSize insideConstraintSize:activeWindow.size];
        self.position = [self positionAtCenterOfGridSized:self.gridSize unitSize:CGSizeMake(kSizeGridUnit, kSizeGridUnit) constraintRect:activeWindow];
    }
    return self;
}

- (NSSet *)createPuzzleArea:(NSInteger)puzzle
{
    // convert puzzle data to area set
    NSMutableSet *area = [NSMutableSet set];
    NSArray *cells = [PuzzleUtils puzzleArea:puzzle];
    for (NSArray *cell in cells) {
        NSString *x = [cell[0] stringValue];
        NSString *y = [cell[1] stringValue];
        [area addObject:[x stringByAppendingString:y]];
    }
    return [NSSet setWithSet:area];
}

- (void)createPuzzleBorder:(NSInteger)puzzle
{
    static NSString *padBorderStrait = @"pad_border_strait.png";
    static NSString *padBorderCorner = @"pad_border_corner.png";
    
    // 0-base index against 1-base index grid size will give us the corner points to create border images
    for (int x = 0; x <= self.gridSize.x; x++) {
        for (int y = 0; y <= self.gridSize.y; y++) {
            
            GridCoord cell = GridCoordMake(x, y);
            
            // find neighbors
            NSString *bottomLeft = [NSString stringWithFormat:@"%i%i", x, y];
            NSString *topLeft = [NSString stringWithFormat:@"%i%i", x, y + 1];
            NSString *bottomRight = [NSString stringWithFormat:@"%i%i", x + 1, y];
            NSString *topRight = [NSString stringWithFormat:@"%i%i", x + 1, y + 1];
            
            BOOL hasBottomLeft = [self.area containsObject:bottomLeft];
            BOOL hasTopLeft = [self.area containsObject:topLeft];
            BOOL hasBottomRight = [self.area containsObject:bottomRight];
            BOOL hasTopRight = [self.area containsObject:topRight];
            
            // cell on every side or no side, no border needed
            if ((hasBottomLeft && hasTopLeft && hasBottomRight && hasTopRight) ||
                (!hasBottomLeft && !hasTopLeft && !hasBottomRight && !hasTopRight))
            {
                continue;
            }
            
            CCSprite *border1;
            CCSprite *border2;
            
            // strait edge vertical
            if ((hasBottomLeft && hasTopLeft && !hasBottomRight && !hasTopRight) ||
                (!hasBottomLeft && !hasTopLeft && hasBottomRight && hasTopRight))
            {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStrait];
            }
            
            // strait edge horizontal
            else if ((hasTopLeft && hasTopRight && !hasBottomLeft && !hasBottomRight) ||
                     (!hasTopLeft && !hasTopRight && hasBottomLeft && hasBottomRight))
            {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStrait];
                border1.rotation = 90;
            }
            
            // top left only
            else if ((hasTopLeft && !hasTopRight && !hasBottomLeft && !hasBottomRight) ||
                     (!hasTopLeft && hasTopRight && hasBottomLeft && hasBottomRight))
            {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
            }
            
            // top right only
            else if ((hasTopRight && !hasTopLeft && !hasBottomLeft && !hasBottomRight) ||
                     (!hasTopRight && hasTopLeft && hasBottomLeft && hasBottomRight))
            {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
                border1.rotation = 90;
            }
            
            // bottom left only
            else if ((hasBottomLeft && !hasBottomRight && !hasTopLeft && !hasTopRight) ||
                     (!hasBottomLeft && hasBottomRight && hasTopLeft && hasTopRight))
            {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
                border1.rotation = -90;
            }
            
            // bottom right only
            else if ((hasBottomRight && !hasBottomLeft && !hasTopLeft && !hasTopRight) ||
                     (!hasBottomRight && hasBottomLeft && hasTopLeft && hasTopRight))
            {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
                border1.rotation = 180;
            }
            
            // both bottom left and top right corner
            else if (hasBottomLeft && hasTopRight && !hasBottomRight && !hasTopLeft) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
                border1.rotation = -90;
                border2 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
                border2.rotation = 90;
            }
            
            // both bottom right and top left corner
            else if (hasBottomRight && hasTopLeft && !hasBottomLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
                border1.rotation = 180;
                border2 = [CCSprite spriteWithSpriteFrameName:padBorderCorner];
            }
            
            // position and add border(s)
            border1.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
            [self.audioObjectsBatchNode addChild:border1];
            
            if (border2 != nil) {
                border2.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
                [self.audioObjectsBatchNode addChild:border2];
            }
        }
    }
}

- (void)createPuzzleObjects:(NSInteger)puzzle
{
    NSArray *audioPads = [PuzzleUtils puzzleAudioPads:puzzle];
    NSDictionary *imageSequenceKey = [PuzzleUtils puzzleImageSequenceKey:puzzle];
    
    for (NSDictionary *pad in audioPads) {
        
        BOOL isStatic = [pad[kStatic] boolValue];
        NSArray *glyphs = pad[kGlyphs];
        
        for (NSDictionary *glyph in glyphs) {
            
            NSArray *rawCoord = glyph[kCell];
            NSArray *coord = @[@([rawCoord[0] intValue] - 1), @([rawCoord[1] intValue] - 1)];
            NSString *entry = glyph[kEntry];
            NSString *arrow = glyph[kArrow];
            NSString *synth = glyph[kSynth];
            NSNumber *midi = glyph[kMidi];
            NSString *sample = glyph[kSample];
            NSString *imageSetBaseName = glyph[kImageSet];
         
            // cell is the only mandatory field to create an audio pad (empty pad can be used as a puzzle object to just take up space)
            if (coord == NULL) {
                NSLog(@"SequenceLayer createPuzzleObjects error: 'cell' must not be null on audio pads");
                return;
            }
            GridCoord cell = GridCoordMake([coord[0] intValue], [coord[1] intValue]);
            CGPoint cellCenter = [GridUtils relativeMidpointForCell:cell unitSize:kSizeGridUnit];
            
            // audio pad sprite
            AudioPad *audioPad = [[AudioPad alloc] initWithCell:cell moveable:!isStatic];
            audioPad.position = cellCenter;
            [self.tickDispatcher registerAudioResponderCellNode:audioPad];
            [self.audioTouchDispatcher addResponder:audioPad];
            [self.audioObjectsBatchNode addChild:audioPad];
            
            // ticker entry point
            if (entry != NULL) {
            }
            
            // pd synth
            if (synth != NULL && midi != NULL) {
                
                NSDictionary *mappedImageSet = [imageSequenceKey objectForKey:imageSetBaseName];
                NSString *imageName = [mappedImageSet objectForKey:midi];
                Tone *tone = [[Tone alloc] initWithCell:cell synth:synth midi:[midi stringValue] frameName:imageName];
                
//                Tone *tone = [[Tone alloc] initWithCell:cell synth:synth midi:midi.stringValue];
//                // [self.tickDispatcher registerAudioResponderCellNode:tone];
                
                [self.audioTouchDispatcher addResponder:tone];
                tone.position = cellCenter;
                [self.audioObjectsBatchNode addChild:tone];
                
                
            }
            
            // audio sample
            if (sample != NULL) {
            }
            
            // direction arrow
            if (arrow != NULL) {
            }
        }
    }
}

//- (void)createPuzzleObjectsOld:(CCTMXTiledMap *)tiledMap
//{
//    // audio pads
//    NSMutableArray *pads = [tiledMap objectsWithName:kTLDObjectAudioPad groupName:kTLDGroupAudioResponders];
//    for (NSMutableDictionary *pad in pads) {
//        
////        GridCoord padChunkOrigin = [tiledMap gridCoordForObject:pad];
////        NSNumber *width = [pad objectForKey:@"width"];
////        NSNumber *height = [pad objectForKey:@"height"];
////        int column = ([width intValue] / kSizeGridUnit);
////        int row = ([height intValue] / kSizeGridUnit);
////        
////        for (int c = 0; c <= column; c++) {
////            for (int r = 0; r <= row; r++) {
////                GridCoord cell = GridCoordMake(padChunkOrigin.x + c, padChunkOrigin.y + r);
////                AudioPad *audioPad = [[AudioPad alloc] initWithCell:cell];
////                audioPad.position = [GridUtils relativeMidpointForCell:cell unitSize:kSizeGridUnit];
////                [self.tickDispatcher registerAudioResponderCellNode:audioPad];
////                [self.audioTouchDispatcher addResponder:audioPad];
////                [self.audioObjectsBatchNode addChild:audioPad];
////            }
////        }
//    }
//    
//    // tone blocks
//    NSMutableArray *tones = [tiledMap objectsWithName:kTLDObjectTone groupName:kTLDGroupAudioResponders];
//    for (NSMutableDictionary *tone in tones) {
//        
//        Tone *toneNode = [[Tone alloc] initWithBatchNode:self.synthBatchNode tone:tone tiledMap:tiledMap];
//        [self.tickDispatcher registerAudioResponderCellNode:toneNode];
//        [self.audioTouchDispatcher addResponder:toneNode];
//        [self addChild:toneNode];
//    }
//    
//    // drum blocks
//    NSMutableArray *drums = [tiledMap objectsWithName:kTLDObjectDrum groupName:kTLDGroupAudioResponders];
//    for (NSMutableDictionary *drum in drums) {
//        Drum *drumNode = [[Drum alloc] initWithDrum:drum batchNode:self.samplesBatchNode tiledMap:tiledMap];
//        [self.tickDispatcher registerAudioResponderCellNode:drumNode];
//        [self.audioTouchDispatcher addResponder:drumNode];
//        [self addChild:drumNode];
//    }
//    
//    //        // arrow blocks
//    //        NSMutableArray *arrows = [tiledMap objectsWithName:kTLDObjectArrow groupName:kTLDGroupAudioResponders];
//    //        for (NSMutableDictionary *arrow in arrows) {
//    //            Arrow *arrowNode = [[Arrow alloc] initWithArrow:arrow tiledMap:tiledMap synth:self.synth];
//    //            [self.tickDispatcher registerAudioResponder:arrowNode];
//    //            [self addChild:arrowNode];
//    //        }
//    
//    // entry arrow
//    NSMutableArray *entries = [tiledMap objectsWithName:kTLDObjectEntry groupName:kTLDGroupAudioResponders];
//    for (NSMutableDictionary *entry in entries) {
//        EntryArrow *entryArrow = [[EntryArrow alloc] initWithBatchNode:self.othersBatchNode entry:entry tiledMap:tiledMap];
//        [self addChild:entryArrow];
//    }
//}

// general rule for legal placement of drag items
- (BOOL)isLegalItemPlacement:(GridCoord)cell itemType:(kDragItem)itemType sender:(id)sender
{
    NSArray *AudioResponders = [self.tickDispatcher AudioRespondersAtCell:cell];
    
    // a stop item can only be placed on an empty audio pad
    if (itemType == kDragItemAudioStop) {
        if (AudioResponders.count == 1) {
            id responder = [AudioResponders lastObject];
            return [responder isKindOfClass:[AudioPad class]];
        }
        else {
            return NO;
        }
    }
    
    // otherwise only place on top of a block
    if (AudioResponders.count == 0) {
        return NO;
    }
    // can't place on top of another object of same type unless it's the source cell
    else {
        for (id responder in AudioResponders) {
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
            [self.tickDispatcher registerAudioResponderCellNode:arrow];
            [self addChild:arrow];
        }
        else if (itemType == kDragItemWarp) {
            Warp *warp = [[Warp alloc] initWithBatchNode:self.othersBatchNode dragItemDelegate:self cell:self.lastDraggedItemCell];
            [self.tickDispatcher registerAudioResponderCellNode:warp];
            [self addChild:warp];
        }
        else if (itemType == kDragItemAudioStop) {
            AudioStop *audioStop = [[AudioStop alloc] initWithBatchNode:self.othersBatchNode cell:self.lastDraggedItemCell dragItemDelegate:self];
            [self.tickDispatcher registerAudioResponderCellNode:audioStop];
            [self.audioTouchDispatcher addResponder:audioStop];
            [self addChild:audioStop];
        }
        else if (itemType == kDragItemSpeedChange) {
            SpeedChange *speedChange = [[SpeedChange alloc] initWithBatchNode:self.othersBatchNode Cell:self.lastDraggedItemCell dragItemDelegate:self speed:@"2X"];
            [self.tickDispatcher registerAudioResponderCellNode:speedChange];
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
        if (![self.tickDispatcher isAnyAudioResponderAtCell:cell]) {
            [self addChild:[SequenceLayer exitFader:cell]];
//            [MainSynth receiveEvents:@[kExitEvent]];
        }
    }
}

@end
