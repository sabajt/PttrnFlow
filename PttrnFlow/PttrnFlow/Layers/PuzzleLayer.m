//
//  PuzzleLayer.m
//  SequencerGame
//
//  Created by John Saba on 1/26/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Arrow.h"
#import "AudioPad.h"
#import "AudioTouchDispatcher.h"
#import "BackgroundLayer.h"
#import "ColorUtils.h"
#import "Coord.h"
#import "Gear.h"
#import "Entry.h"
#import "GameConstants.h"
#import "MainSynth.h"
#import "PdDispatcher.h"
#import "PFGeometry.h"
#import "PFLPuzzle.h"
#import "PuzzleLayer.h"
#import "SequenceControlsLayer.h"
#import "SequenceDispatcher.h"
#import "SimpleAudioEngine.h"
#import "Synth.h"
#import "PFLGlyph.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"

typedef NS_ENUM(NSInteger, ZOrderAudioBatch)
{
    ZOrderAudioBatchPanelFill = 0,
    ZOrderAudioBatchPanelBorder,
    ZOrderAudioBatchPadBacklight,
    ZOrderAudioBatchPad,
    ZOrderAudioBatchGlyph
};

static CGFloat kPuzzleBoundsMargin = 10.0f;

@interface PuzzleLayer ()

@property (weak, nonatomic) BackgroundLayer *backgroundLayer;
@property (assign) CGFloat beatDuration;
@property (assign) CGPoint gridOrigin; // TODO: using grid origin except for drawing debug grid?
@property (assign) Coord *maxCoord;
@property (weak, nonatomic) Synth *pressedSynth;
@property (assign) CGRect puzzleBounds;
@property (assign) CGSize screenSize;
@property (assign) BOOL shouldDrawGrid; // debugging

@end

@implementation PuzzleLayer

#pragma mark - setup

+ (CCScene *)sceneWithPuzzle:(PFLPuzzle *)puzzle
{
    CCScene *scene = [CCScene node];
    
    // background
    BackgroundLayer *background = [BackgroundLayer backgroundLayer];
    [scene addChild:background];
    
    // gameplay layer
    static CGFloat controlBarHeight = 80.0f;
    PuzzleLayer *puzzleLayer = [[PuzzleLayer alloc] initWithPuzzle:puzzle background:background topMargin:controlBarHeight];
    [scene addChild:puzzleLayer];
        
    // controls layer
    SequenceControlsLayer *uiLayer = [[SequenceControlsLayer alloc] initWithPuzzle:puzzle delegate:puzzleLayer.sequenceDispatcher];
    [scene addChild:uiLayer z:1];
    
    return scene;
}

- (id)initWithPuzzle:(PFLPuzzle *)puzzle background:(BackgroundLayer *)backgroundLayer topMargin:(CGFloat)topMargin;
{
    self = [super init];
    if (self) {
        // layer initialized with default content size of screen size...
        // would be better to do figure out best practice and get screen size more explicitly
        self.screenSize = self.contentSize;
        
        // Initialize Pure Data stuff
        
        _dispatcher = [[PdDispatcher alloc] init];
        [PdBase setDelegate:_dispatcher];
        _patch = [PdBase openFile:@"pf-main.pd" path:[[NSBundle mainBundle] resourcePath]];
        if (!_patch) {
            CCLOG(@"Failed to open patch");
        }
        
        // TODO: fix me with PuzzleSet
        // TODO: fix me with PuzzleSet
        self.beatDuration = 0.5f;
        [MainSynth sharedMainSynth].beatDuration = self.beatDuration;
        
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
        [self addChild:[MainSynth sharedMainSynth]]; // must add main synth so it can run actions
        self.isTouchEnabled = YES;
        self.backgroundLayer = backgroundLayer;
        
        NSArray *areaCells = [Coord coordsFromArrays:puzzle.area];
        
        self.maxCoord = [Coord maxCoord:areaCells];
        self.contentSize = CGSizeMake((self.maxCoord.x + 1) * kSizeGridUnit, (self.maxCoord.y + 1) * kSizeGridUnit);
        
        self.puzzleBounds = CGRectMake(kPuzzleBoundsMargin,
                                       (3 * kUIButtonUnitSize) + kPuzzleBoundsMargin,
                                       self.screenSize.width - (2 * kPuzzleBoundsMargin),
                                       self.screenSize.height - (4 * kUIButtonUnitSize) - (2 * kPuzzleBoundsMargin));
        
        if (self.contentSize.width >= self.puzzleBounds.size.width) {
            self.position = ccp(self.puzzleBounds.origin.x, self.position.y);
        }
        else {
            self.allowsScrollHorizontal = NO;
            CGFloat padding = self.puzzleBounds.size.width - self.contentSize.width;
            self.position = ccp(self.puzzleBounds.origin.x + (padding / 2), self.position.y);
        }
        
        if (self.contentSize.height >= self.puzzleBounds.size.height) {
            self.position = ccp(self.position.x, self.puzzleBounds.origin.y);
        }
        else {
            self.allowsScrollVertical = NO;
            CGFloat padding = self.puzzleBounds.size.height - self.contentSize.height;
            self.position = ccp(self.position.x, self.puzzleBounds.origin.y + (padding / 2));
        }
        self.scrollBounds = CGRectMake(self.position.x, self.position.y, (self.screenSize.width - kPuzzleBoundsMargin) - self.position.x, (self.screenSize.height - kPuzzleBoundsMargin) - self.position.y);
        CCLOG(@"scroll bounds: %@", NSStringFromCGRect(self.scrollBounds));
        
        // audio touch dispatcher
        CGFloat beatDuration = self.beatDuration;
        AudioTouchDispatcher *audioTouchDispatcher = [[AudioTouchDispatcher alloc] initWithBeatDuration:beatDuration];
        self.audioTouchDispatcher = audioTouchDispatcher;
        self.scrollDelegate = audioTouchDispatcher;
        [audioTouchDispatcher clearResponders];
        audioTouchDispatcher.areaCells = areaCells;
        [self addChild:audioTouchDispatcher];
        
        // sequence dispacher
        SequenceDispatcher *sequenceDispatcher = [[SequenceDispatcher alloc] initWithPuzzle:puzzle];
        self.sequenceDispatcher = sequenceDispatcher;
        [sequenceDispatcher clearResponders];
        [self addChild:sequenceDispatcher];
        
        // create puzzle objects
        [self createBorderWithAreaCells:areaCells];
        [self createPuzzleObjects:puzzle];
    }
    return self;
}

- (void)createBorderWithAreaCells:(NSArray *)areaCells
{
    static NSString *padBorderStraitEdge = @"pad_border_strait_edge.png";
    static NSString *padBorderStraitRightFill = @"pad_border_strait_right_fill.png";
    static NSString *padBorderCornerEdge = @"pad_border_corner_edge.png";
    static NSString *padBorderCornerInsideFill = @"pad_border_corner_inside_fill.png";
    static NSString *padBorderCornerOutsideFill = @"pad_border_corner_outside_fill.png";

    for (NSInteger x = -1; x <= self.maxCoord.x; x++) {
        for (NSInteger y = -1; y <= self.maxCoord.y; y++) {
            
            Coord *cell = [Coord coordWithX:x Y:y];
            
            // find neighbor corners
            Coord *bottomleft = [Coord coordWithX:x Y:y];
            Coord *topLeft = [Coord coordWithX:x Y:y + 1];
            Coord *bottomRight = [Coord coordWithX:x + 1 Y:y];
            Coord *topRight = [Coord coordWithX:x + 1 Y:y + 1];
            
            BOOL hasBottomLeft = [bottomleft isCoordInGroup:areaCells];
            BOOL hasTopLeft = [topLeft isCoordInGroup:areaCells];
            BOOL hasBottomRight = [bottomRight isCoordInGroup:areaCells];
            BOOL hasTopRight = [topRight isCoordInGroup:areaCells];
            
            // cell on every side, fill panel instead of border needed
            if (hasBottomLeft && hasTopLeft && hasBottomRight && hasTopRight) {
                CCSprite *padFill = [CCSprite spriteWithSpriteFrameName:@"pad_fill.png"];
                padFill.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
                padFill.color = [ColorUtils cream];
                [self.audioObjectsBatchNode addChild:padFill z:ZOrderAudioBatchPanelFill];
                continue;
            }
            // cell on no side, nothing needed
            if (!hasBottomLeft && !hasTopLeft && !hasBottomRight && !hasTopRight) {
                continue;
            }
            
            CCSprite *border1;
            CCSprite *fill1;
            CCSprite *border2;
            CCSprite *fill2;
            
            // strait edge vertical
            if (hasBottomLeft && hasTopLeft && !hasBottomRight && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitEdge];
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
                fill1.scale *= -1;
            }
            else if (!hasBottomLeft && !hasTopLeft && hasBottomRight && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitEdge];
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
            }

            // strait edge horizontal
            else if (hasTopLeft && hasTopRight && !hasBottomLeft && !hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitEdge];
                border1.rotation = -90.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
                fill1.rotation = -90.0f;
            }
            else if (!hasTopLeft && !hasTopRight && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitEdge];
                border1.rotation = 90.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
                fill1.rotation = 90.0f;
            }

            // top left only
            else if (hasTopLeft && !hasTopRight && !hasBottomLeft && !hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
            }
            else if (!hasTopLeft && hasTopRight && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutsideFill];
            }
            
            // top right only
            else if (hasTopRight && !hasTopLeft && !hasBottomLeft && !hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = 90.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
                fill1.rotation = 90.0f;
            }
            else if (!hasTopRight && hasTopLeft && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = 90.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutsideFill];
                fill1.rotation = 90.0f;
            }
            
            // bottom left only
            else if (hasBottomLeft && !hasBottomRight && !hasTopLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = -90.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
                fill1.rotation = -90.0f;
            }
            else if (!hasBottomLeft && hasBottomRight && hasTopLeft && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = -90.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutsideFill];
                fill1.rotation = -90.0f;
            }
            
            // bottom right only
            else if (hasBottomRight && !hasBottomLeft && !hasTopLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = 180.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
                fill1.rotation = 180.0f;
            }
            else if (!hasBottomRight && hasBottomLeft && hasTopLeft && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = 180.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutsideFill];
                fill1.rotation = 180.0f;
            }

            // both bottom left and top right corner
            else if (hasBottomLeft && hasTopRight && !hasBottomRight && !hasTopLeft) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = -90.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
                fill1.rotation = -90.0f;
                
                border2 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border2.rotation = 90.0f;
                fill2 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
                fill2.rotation = 90.0f;
            }
            
            // both bottom right and top left cornerh
            else if (hasBottomRight && hasTopLeft && !hasBottomLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                border1.rotation = 180.0f;
                fill1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
                fill1.rotation = 180.0f;
                
                border2 = [CCSprite spriteWithSpriteFrameName:padBorderCornerEdge];
                fill2 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInsideFill];
            }
            
            fill1.color = [ColorUtils cream];
            fill1.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
            [self.audioObjectsBatchNode addChild:fill1 z:ZOrderAudioBatchPanelBorder];
            
            border1.color = [ColorUtils dimPurple];
            border1.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
            [self.audioObjectsBatchNode addChild:border1 z:ZOrderAudioBatchPanelBorder];
            
            if (border2 != nil) {
                fill2.color = [ColorUtils cream];
                fill2.position = fill1.position;
                [self.audioObjectsBatchNode addChild:fill2 z:ZOrderAudioBatchPanelBorder];
                
                border2.color = [ColorUtils dimPurple];
                border2.position = border1.position;
                [self.audioObjectsBatchNode addChild:border2 z:ZOrderAudioBatchPanelBorder];
            }
        }
    }
}

- (void)createPuzzleObjects:(PFLPuzzle *)puzzle
{
    NSArray *glyphs = puzzle.glyphs;
    
    // collect sample names so we can load them in PD tables
    NSMutableArray *allSampleNames = [NSMutableArray array];
    
    for (PFLGlyph *glyph in glyphs) {

        // cell is the only mandatory field to create an audio pad (empty pad can be used as a puzzle object to just take up space)
        if (!glyph.cell) {
            CCLOG(@"SequenceLayer createPuzzleObjects error: 'cell' must not be null on audio pads");
            return;
        }
        CGPoint cellCenter = [glyph.cell relativeMidpoint];
        
        // audio pad sprite
        AudioPad *audioPad = [[AudioPad alloc] initWithPlaceholderFrameName:@"clear_rect_audio_batch.png" cell:glyph.cell isStatic:glyph.isStatic];

        audioPad.position = cellCenter;
        [self.audioTouchDispatcher addResponder:audioPad];
        [self.sequenceDispatcher addResponder:audioPad];
        [self.audioObjectsBatchNode addChild:audioPad z:ZOrderAudioBatchPad];
        
        if (glyph.audioID) {
            id object = puzzle.audio[[glyph.audioID integerValue]];
            
            if ([object isKindOfClass:[PFLMultiSample class]]) {
                PFLMultiSample *multiSample = (PFLMultiSample *)object;
                Gear *gear = [[Gear alloc] initWithCell:glyph.cell audioID:glyph.audioID multiSample:multiSample isStatic:glyph.isStatic];
                [self.audioTouchDispatcher addResponder:gear];
                [self.sequenceDispatcher addResponder:gear];
                gear.position = cellCenter;
                [self.audioObjectsBatchNode addChild:gear z:ZOrderAudioBatchGlyph];
                
                for (PFLSample *sample in multiSample.samples) {
                    [allSampleNames addObject:sample.file];
                }
            }
        }
        
        // direction arrow
        if (glyph.arrow) {
            Arrow *arrow = [[Arrow alloc] initWithCell:glyph.cell direction:glyph.arrow isStatic:glyph.isStatic];
            [self.audioTouchDispatcher addResponder:arrow];
            [self.sequenceDispatcher addResponder:arrow];
            arrow.position = cellCenter;
            [self.audioObjectsBatchNode addChild:arrow z:ZOrderAudioBatchGlyph];
        }
        
        // entry point
        if (glyph.entry) {
            Entry *entry = [[Entry alloc] initWithCell:glyph.cell direction:glyph.entry isStatic:glyph.isStatic];
            [self.audioTouchDispatcher addResponder:entry];
            [self.sequenceDispatcher addResponder:entry];
            self.sequenceDispatcher.entry = entry;
            entry.position = cellCenter;
            [self.audioObjectsBatchNode addChild:entry z:ZOrderAudioBatchGlyph];
        }
    }
    [[MainSynth sharedMainSynth] loadSamples:allSampleNames];
}

- (void)animateEmptyHitHighlight:(Coord *)coord
{
    CCSprite *highlightSprite = [CCSprite spriteWithSpriteFrameName:@"audio_box_highlight.png"];
    highlightSprite.position = [coord relativeMidpoint];
    [self.audioObjectsBatchNode addChild:highlightSprite z:ZOrderAudioBatchPadBacklight];
    
    CCCallBlock *completion = [CCCallBlock actionWithBlock:^{
        [highlightSprite removeFromParentAndCleanup:YES];
    }];
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:self.beatDuration];
    [highlightSprite runAction:[CCSequence actions:[CCEaseSineOut actionWithAction:fadeOut], completion, nil]];
}

#pragma mark - scene management
// TODO: opening and closing pd patch not matched with onEnter / onExit would cause pd patch to not be opened if
// TODO: leaving scene but keeping sequence layer around then coming back to seq layer

- (void)onEnter
{
    [super onEnter];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handleStepUserSequence:) name:kNotificationStepUserSequence object:nil];
    [self setupDebug];
}

- (void)onExit
{    
    [PdBase closeFile:_patch];
    [PdBase setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

#pragma mark - SequenceDispatcherDelegate

- (void)handleStepUserSequence:(NSNotification *)notification
{
    Coord *coord = notification.userInfo[kKeyCoord];
    BOOL empty = [notification.userInfo[kKeyEmpty] boolValue];
    
    if (empty) {
        [self animateEmptyHitHighlight:coord];
    }
}

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
    
    // // draw bounding box over puzzle layer content box
    // CCSprite *rectSprite = [CCSprite rectSpriteWithSize:CGSizeMake(self.contentSize.width, self.contentSize.height) color:ccRED];
    // rectSprite.anchorPoint = ccp(0, 0);
    // rectSprite.position = ccp(0, 0);
    // rectSprite.opacity = 100;
    // [self addChild:rectSprite];
}

- (void)reportSize:(ccTime)deltaTime
{
    CCLOG(@"\n\n--debug------------------------");
    CCLOG(@"seq layer content size: %@", NSStringFromCGSize(self.contentSize));
    CCLOG(@"seq layer bounding box: %@", NSStringFromCGRect(self.boundingBox));
    CCLOG(@"seq layer position: %@", NSStringFromCGPoint(self.position));
    CCLOG(@"seq layer scale: %g", self.scale);
    CCLOG(@"--end debug------------------------\n");
}

//- (void)draw
//{
//    // grid
//    if (self.shouldDrawGrid) {
//        ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
//        [GridUtils drawGridWithSize:self.maxCoord unitSize:kSizeGridUnit origin:_gridOrigin];
//    }
//}

@end
