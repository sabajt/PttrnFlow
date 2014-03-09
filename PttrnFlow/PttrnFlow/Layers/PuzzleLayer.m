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
#import "Drum.h"
#import "Entry.h"
#import "GameConstants.h"
#import "MainSynth.h"
#import "PdDispatcher.h"
#import "PFGeometry.h"
#import "PuzzleDataManager.h"
#import "PuzzleLayer.h"
#import "Sample.h"
#import "SequenceControlsLayer.h"
#import "SequenceDispatcher.h"
#import "SimpleAudioEngine.h"
#import "Synth.h"

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
@property (assign) CGPoint gridOrigin; // TODO: using grid origin except for drawing debug grid?
@property (assign) Coord *maxCoord;
@property (weak, nonatomic) Synth *pressedSynth;
@property (assign) CGRect puzzleBounds;
@property (assign) CGSize screenSize;
@property (assign) BOOL shouldDrawGrid; // debugging

@end

@implementation PuzzleLayer

#pragma mark - setup

+ (CCScene *)sceneWithSequence:(int)sequence
{
    CCScene *scene = [CCScene node];
    
    // background
    BackgroundLayer *background = [BackgroundLayer backgroundLayer];
    [scene addChild:background];
    
    // gameplay layer
    static CGFloat controlBarHeight = 80.0f;
    PuzzleLayer *puzzleLayer = [[PuzzleLayer alloc] initWithSequence:sequence background:background topMargin:controlBarHeight];
    [scene addChild:puzzleLayer];
        
    // controls layer
    SequenceControlsLayer *uiLayer = [[SequenceControlsLayer alloc] initWithPuzzle:sequence delegate:puzzleLayer.sequenceDispatcher];
    [scene addChild:uiLayer z:1];
        
    return scene;
}

- (id)initWithSequence:(int)sequence background:(BackgroundLayer *)backgroundLayer topMargin:(CGFloat)topMargin;
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
        [MainSynth sharedMainSynth].beatDuration = [[PuzzleDataManager sharedManager] puzzleBeatDuration:sequence];
        
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
        
        NSArray *cells = [[PuzzleDataManager sharedManager] puzzleArea:sequence];
        
        self.maxCoord = [Coord maxCoord:cells];
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
        CGFloat beatDuration = [[PuzzleDataManager sharedManager] puzzleBeatDuration:sequence];
        AudioTouchDispatcher *audioTouchDispatcher = [[AudioTouchDispatcher alloc] initWithBeatDuration:beatDuration];
        self.audioTouchDispatcher = audioTouchDispatcher;
        self.scrollDelegate = audioTouchDispatcher;
        [audioTouchDispatcher clearResponders];
        audioTouchDispatcher.areaCells = [[PuzzleDataManager sharedManager] puzzleArea:sequence];
        [self addChild:audioTouchDispatcher];
        
        // sequence dispacher
        SequenceDispatcher *sequenceDispatcher = [[SequenceDispatcher alloc] initWithPuzzle:sequence];
        self.sequenceDispatcher = sequenceDispatcher;
        [sequenceDispatcher clearResponders];
        [self addChild:sequenceDispatcher];
        
        // create puzzle objects
        self.areaCells = [[PuzzleDataManager sharedManager] puzzleArea:sequence];
        [self createPuzzleBorder:sequence];
        [self createPuzzleObjects:sequence];
    }
    return self;
}

- (void)createPuzzleBorder:(NSInteger)puzzle
{
    static NSString *padBorderStraitRightFill = @"pad_border_strait_right_fill.png";
    static NSString *padBorderCornerInside = @"pad_border_corner_inside.png";
    static NSString *padBorderCornerOutside = @"pad_border_corner_outside.png";

    for (NSInteger x = -1; x <= self.maxCoord.x; x++) {
        for (NSInteger y = -1; y <= self.maxCoord.y; y++) {
            
            Coord *cell = [Coord coordWithX:x Y:y];
            
            // find neighbor corners
            Coord *bottomleft = [Coord coordWithX:x Y:y];
            Coord *topLeft = [Coord coordWithX:x Y:y + 1];
            Coord *bottomRight = [Coord coordWithX:x + 1 Y:y];
            Coord *topRight = [Coord coordWithX:x + 1 Y:y + 1];
            
            BOOL hasBottomLeft = [bottomleft isCoordInGroup:self.areaCells];
            BOOL hasTopLeft = [topLeft isCoordInGroup:self.areaCells];
            BOOL hasBottomRight = [bottomRight isCoordInGroup:self.areaCells];
            BOOL hasTopRight = [topRight isCoordInGroup:self.areaCells];
            
            // cell on every side, fill panel instead of border needed
            if (hasBottomLeft && hasTopLeft && hasBottomRight && hasTopRight) {
                CCSprite *padFill = [CCSprite spriteWithSpriteFrameName:@"pad_fill.png"];
                padFill.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
                [self.audioObjectsBatchNode addChild:padFill z:ZOrderAudioBatchPanelFill];
                continue;
            }
            // cell on no side, nothing needed
            if (!hasBottomLeft && !hasTopLeft && !hasBottomRight && !hasTopRight) {
                continue;
            }
            
            CCSprite *border1;
            CCSprite *border2;
            
            // strait edge vertical
            if (hasBottomLeft && hasTopLeft && !hasBottomRight && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
                border1.scale *= -1;
            }
            else if (!hasBottomLeft && !hasTopLeft && hasBottomRight && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
            }

            // strait edge horizontal
            else if (hasTopLeft && hasTopRight && !hasBottomLeft && !hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
                border1.rotation = -90.0f;
            }
            else if (!hasTopLeft && !hasTopRight && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
                border1.rotation = 90.0f;
            }

            // top left only
            else if (hasTopLeft && !hasTopRight && !hasBottomLeft && !hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
            }
            else if (!hasTopLeft && hasTopRight && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutside];
            }
            
            // top right only
            else if (hasTopRight && !hasTopLeft && !hasBottomLeft && !hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = 90.0f;
            }
            else if (!hasTopRight && hasTopLeft && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutside];
                border1.rotation = 90.0f;
            }
            
            // bottom left only
            else if (hasBottomLeft && !hasBottomRight && !hasTopLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = -90.0f;
            }
            else if (!hasBottomLeft && hasBottomRight && hasTopLeft && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutside];
                border1.rotation = -90.0f;
            }
            
            // bottom right only
            else if (hasBottomRight && !hasBottomLeft && !hasTopLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = 180.0f;
            }
            else if (!hasBottomRight && hasBottomLeft && hasTopLeft && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutside];
                border1.rotation = 180.0f;
            }

            // both bottom left and top right corner
            else if (hasBottomLeft && hasTopRight && !hasBottomRight && !hasTopLeft) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = -90.0f;
                border2 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border2.rotation = 90.0f;
            }
            
            // both bottom right and top left corner
            else if (hasBottomRight && hasTopLeft && !hasBottomLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = 180.0f;
                border2 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
            }
            
            // position and add border(s)
            border1.position = [[[cell stepInDirection:kDirectionRight] stepInDirection:kDirectionUp] relativePosition];
            [self.audioObjectsBatchNode addChild:border1 z:ZOrderAudioBatchPanelBorder];
            
            if (border2 != nil) {
                border2.position = border1.position;
                [self.audioObjectsBatchNode addChild:border2 z:ZOrderAudioBatchPanelBorder];
            }
        }
    }
}

- (void)createPuzzleObjects:(NSInteger)puzzle
{
    NSArray *glyphs = [[PuzzleDataManager sharedManager] puzzleGlyphs:puzzle];
    
    // collect sample names so we can load them in PD tables
    NSMutableArray *allSampleNames = [NSMutableArray array];
    
    for (NSDictionary *glyph in glyphs) {
        BOOL isStatic = [glyph[kStatic] boolValue];
        NSArray *cellArray = glyph[kCell];
        NSString *entryDirection = glyph[kEntry];
        NSString *arrowDirection = glyph[kArrow];
        NSNumber *audioID = glyph[kAudio];
        
        // cell is the only mandatory field to create an audio pad (empty pad can be used as a puzzle object to just take up space)
        if (!cellArray) {
            CCLOG(@"SequenceLayer createPuzzleObjects error: 'cell' must not be null on audio pads");
            return;
        }
        Coord *cell = [Coord coordWithX:[cellArray[0] integerValue] Y:[cellArray[1] integerValue]];
        CGPoint cellCenter = [cell relativeMidpoint];
        
        // audio pad sprite
        AudioPad *audioPad = [[AudioPad alloc] initWithPlaceholderFrameName:@"clear_rect_audio_batch.png" cell:cell isStatic:isStatic];

        audioPad.position = cellCenter;
        [self.audioTouchDispatcher addResponder:audioPad];
        [self.sequenceDispatcher addResponder:audioPad];
        [self.audioObjectsBatchNode addChild:audioPad z:ZOrderAudioBatchPad];
        
        if (audioID) {
            NSDictionary *audioData = [[PuzzleDataManager sharedManager] puzzle:puzzle audioID:[audioID integerValue]];
            NSAssert(audioData != nil, @"No audio data found for audio id: %@", audioID);
            
            NSDictionary *toneData = audioData[kTone];
            NSArray *drumsData = audioData[kDrums];
            
            if (toneData) {
                NSString *fileName = toneData[kFile];
                NSString *synthName = toneData[kSynth];
                NSNumber *midi = toneData[kMidi];
                NSString *imageName = toneData[kImage];
                NSString *decoratorImageName = toneData[kDecorator];
                
                // pd synth tonal instrument
                if (synthName && midi) {
                    Synth *synth = [[Synth alloc] initWithCell:cell audioID:audioID synth:synthName midi:midi image:imageName decorator:decoratorImageName];
                    [self.audioTouchDispatcher addResponder:synth];
                    [self.sequenceDispatcher addResponder:synth];
                    synth.position = cellCenter;
                    [self.audioObjectsBatchNode addChild:synth z:ZOrderAudioBatchGlyph];
                }
                // sample-based tonal instrument
                else if (fileName) {
                    [allSampleNames addObject:fileName];
                    Sample *sample = [[Sample alloc] initWithCell:cell audioID:audioID image:imageName file:fileName];
                    [self.audioTouchDispatcher addResponder:sample];
                    [self.sequenceDispatcher addResponder:sample];
                    sample.position = cellCenter;
                    [self.audioObjectsBatchNode addChild:sample z:ZOrderAudioBatchGlyph];
                }
                else {
                    CCLOG(@"\n\nWARNING: tone data is not formatted correctly: \n%@\n\n", toneData);
                }
            }
            // a percussion instrument
            else if (drumsData) {
                for (NSDictionary *unit in drumsData) {
                    [allSampleNames addObject:unit[kFile]];
                }
                Drum *drum = [[Drum alloc] initWithCell:cell audioID:audioID data:drumsData isStatic:isStatic];
                [self.audioTouchDispatcher addResponder:drum];
                [self.sequenceDispatcher addResponder:drum];
                drum.position = cellCenter;
                [self.audioObjectsBatchNode addChild:drum z:ZOrderAudioBatchGlyph];
            }
            else {
                CCLOG(@"\n\nWARNING: audio data does not contain supported types '%@' or '%@':\n%@\n\n", kTone, kDrums, audioData);
            }
        }
        
        // direction arrow
        if (arrowDirection) {
            Arrow *arrow = [[Arrow alloc] initWithCell:cell direction:arrowDirection isStatic:isStatic];
            [self.audioTouchDispatcher addResponder:arrow];
            [self.sequenceDispatcher addResponder:arrow];
            arrow.position = cellCenter;
            [self.audioObjectsBatchNode addChild:arrow z:ZOrderAudioBatchGlyph];
        }
        
        // entry point
        if (entryDirection) {
            Entry *entry = [[Entry alloc] initWithCell:cell direction:entryDirection isStatic:isStatic];
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
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1];
    [highlightSprite runAction:[CCSequence actions:fadeOut, completion, nil]];
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
