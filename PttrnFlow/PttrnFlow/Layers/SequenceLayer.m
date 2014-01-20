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
#import "SGTiledUtils.h"
#import "Synth.h"
#import "SGTiledUtils.h"
//#import "Arrow.h"
#import "MainSynth.h"
//#import "EntryArrow.h"
#import "ColorUtils.h"
#import "PdDispatcher.h"
#import "Sample.h"
#import "ColorUtils.h"
#import "CCLayer+Positioning.h"
#import "BackgroundLayer.h"
#import "CCSprite+Utils.h"
//#import "Warp.h"
#import "AudioTouchDispatcher.h"
#import "AudioPad.h"
//#import "AudioStop.h"
#import "TextureUtils.h"
#import "PuzzleUtils.h"
#import "Coord.h"
#import "PFGeometry.h"

typedef NS_ENUM(NSInteger, ZOrderAudioBatch)
{
    ZOrderAudioBatchPanelFill = 0,
    ZOrderAudioBatchPanelBorder,
    ZOrderAudioBatchPadConnector,
    ZOrderAudioBatchPad,
    ZOrderAudioBatchGlyph
};

static CGFloat kPuzzleBoundsMargin = 10.0;
static CGFloat kSequenceInterval = 0.5;

@interface SequenceLayer ()

@property (assign) CGSize screenSize;
@property (assign) Coord *maxCoord;
@property (assign) CGPoint gridOrigin; // TODO: using grid origin except for drawing debug grid?
@property (assign) CGRect puzzleBounds;
@property (assign) BOOL shouldDrawGrid; // debugging
@property (strong, nonatomic) MainSynth *synth;
@property (weak, nonatomic) Synth *pressedSynth;
@property (weak, nonatomic) BackgroundLayer *backgroundLayer;
@property (weak, nonatomic) NSMutableArray *responders;

// sequence
@property (assign) NSInteger userSequenceIndex;
@property (assign) NSInteger solutionSequenceIndex;

@end


@implementation SequenceLayer

#pragma mark - setup

+ (CCScene *)sceneWithSequence:(int)sequence
{
    CCScene *scene = [CCScene node];
    
    // background
    BackgroundLayer *background = [BackgroundLayer backgroundLayer];
    [scene addChild:background];
    
    // gameplay layer
    static CGFloat controlBarHeight = 80;
    SequenceLayer *sequenceLayer = [[SequenceLayer alloc] initWithSequence:sequence background:background topMargin:controlBarHeight];
    [scene addChild:sequenceLayer];
    
    // hud layer -- controls / item menu
    SequenceUILayer *uiLayer = [[SequenceUILayer alloc] initWithPuzzle:sequence delegate:sequenceLayer];
    [scene addChild:uiLayer z:1];
    
    return scene;
}

- (id)initWithSequence:(int)sequence background:(BackgroundLayer *)backgroundLayer topMargin:(CGFloat)topMargin;
{
    self = [super init];
    if (self) {
        self.screenSize = self.contentSize;
        
        self.isTouchEnabled = NO;
        
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
        
        self.maxCoord = [Coord maxCoord:cells];
        self.contentSize = CGSizeMake(self.maxCoord.x * kSizeGridUnit, self.maxCoord.y * kSizeGridUnit);
        
        self.puzzleBounds = CGRectMake(kPuzzleBoundsMargin,
                                       (3 * kUIButtonUnitSize) + kPuzzleBoundsMargin,
                                       self.screenSize.width - (2 * kPuzzleBoundsMargin),
                                       self.screenSize.height - (4 * kUIButtonUnitSize) - (2 * kPuzzleBoundsMargin));
        
        if (self.contentSize.width >= self.puzzleBounds.size.width) {
            self.allowsPanHorizontal = YES;
            self.position = ccp(self.puzzleBounds.origin.x, self.position.y);
        }
        else {
            CGFloat padding = self.puzzleBounds.size.width - self.contentSize.width;
            self.position = ccp(self.puzzleBounds.origin.x + (padding / 2), self.position.y);
        }
        
        if (self.contentSize.height >= self.puzzleBounds.size.height) {
            self.allowsPanVertical = YES;
            self.position = ccp(self.position.x, self.puzzleBounds.origin.y);
        }
        else {
            CGFloat padding = self.puzzleBounds.size.height - self.contentSize.height;
            self.position = ccp(self.position.x, self.puzzleBounds.origin.y + (padding / 2));
        }
        
        // audio touch dispatcher
        AudioTouchDispatcher *sharedTouchDispatcher = [AudioTouchDispatcher sharedAudioTouchDispatcher];
        sharedTouchDispatcher.areaCells = [PuzzleUtils puzzleArea:sequence];
        self.panDelegate = sharedTouchDispatcher;
        [self addChild:sharedTouchDispatcher];
        
        // create puzzle objects
        self.areaCells = [PuzzleUtils puzzleArea:sequence];
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

    // 0-base index against 1-base index grid size will give us the corner points to create border images
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
                border1.rotation = -90;
            }
            else if (!hasTopLeft && !hasTopRight && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderStraitRightFill];
                border1.rotation = 90;
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
                border1.rotation = 90;
            }
            else if (!hasTopRight && hasTopLeft && hasBottomLeft && hasBottomRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutside];
                border1.rotation = 90;
            }
            
            // bottom left only
            else if (hasBottomLeft && !hasBottomRight && !hasTopLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = -90;
            }
            else if (!hasBottomLeft && hasBottomRight && hasTopLeft && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutside];
                border1.rotation = -90;
            }
            
            // bottom right only
            else if (hasBottomRight && !hasBottomLeft && !hasTopLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = 180;
            }
            else if (!hasBottomRight && hasBottomLeft && hasTopLeft && hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerOutside];
                border1.rotation = 180;
            }

            // both bottom left and top right corner
            else if (hasBottomLeft && hasTopRight && !hasBottomRight && !hasTopLeft) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = -90;
                border2 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border2.rotation = 90;
            }
            
            // both bottom right and top left corner
            else if (hasBottomRight && hasTopLeft && !hasBottomLeft && !hasTopRight) {
                border1 = [CCSprite spriteWithSpriteFrameName:padBorderCornerInside];
                border1.rotation = 180;
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
    NSArray *glyphs = [PuzzleUtils puzzleGlyphs:puzzle];
    NSDictionary *imageSequenceKey = [PuzzleUtils puzzleImageSequenceKey:puzzle];
    
    // collect sample names so we can load them in PD tables
    NSMutableArray *allSampleNames = [NSMutableArray array];
    
    for (NSDictionary *glyph in glyphs) {
        BOOL isStatic = [glyph[kStatic] boolValue];
        NSArray *cellArray = glyph[kCell];
        NSString *entry = glyph[kEntry];
        NSString *arrow = glyph[kArrow];
        NSString *synthName = glyph[kSynth];
        NSNumber *midi = glyph[kMidi];
        NSString *sampleName = glyph[kSample];
        NSString *imageSetBaseName = glyph[kImageSet];
     
        // cell is the only mandatory field to create an audio pad (empty pad can be used as a puzzle object to just take up space)
        if (cellArray == NULL) {
            NSLog(@"SequenceLayer createPuzzleObjects error: 'cell' must not be null on audio pads");
            return;
        }
        Coord *cell = [Coord coordWithX:[cellArray[0] integerValue] Y:[cellArray[1] integerValue]];
        CGPoint cellCenter = [cell relativeMidpoint];
        
        // audio pad unit sprite
        AudioPad *audioPadUnit = [[AudioPad alloc] initWithPlaceholderFrameName:@"clear_rect_audio_batch.png" cell:cell isStatic:isStatic];

        audioPadUnit.position = cellCenter;
        [[AudioTouchDispatcher sharedAudioTouchDispatcher] addResponder:audioPadUnit];
        [self addAudioResponder:audioPadUnit];
        [self.audioObjectsBatchNode addChild:audioPadUnit z:ZOrderAudioBatchPad];
        
        // ticker entry point
        if (entry != NULL) {
        }
        
        // pd synth
        if (synthName != NULL && midi != NULL) {
            
            NSDictionary *mappedImageSet = [imageSequenceKey objectForKey:imageSetBaseName];
            NSString *imageName = [mappedImageSet objectForKey:midi];
            Synth *synth = [[Synth alloc] initWithCell:cell synth:synthName midi:[midi stringValue] frameName:imageName];
            
            [[AudioTouchDispatcher sharedAudioTouchDispatcher] addResponder:synth];
            [self addAudioResponder:synth];
            
            synth.position = cellCenter;
            [self.audioObjectsBatchNode addChild:synth z:ZOrderAudioBatchGlyph];
        }
        
        // audio sample
        if (sampleName != NULL) {
            [allSampleNames addObject:sampleName];
            
            NSDictionary *mappedImageSet = [imageSequenceKey objectForKey:imageSetBaseName];
            NSString *imageName = [mappedImageSet objectForKey:sampleName];
            Sample *sample = [[Sample alloc] initWithCell:cell sampleName:sampleName frameName:imageName];
            
            [[AudioTouchDispatcher sharedAudioTouchDispatcher] addResponder:sample];
            [self addAudioResponder:sample];
            
            sample.position = cellCenter;
            [self.audioObjectsBatchNode addChild:sample z:ZOrderAudioBatchGlyph];
        }
        
        // direction arrow
        if (arrow != NULL) {
        }
    }
    [[MainSynth sharedMainSynth] loadSamples:allSampleNames];
}

#pragma mark - PuzzleControlsDelegate

- (void)startUserSequence
{
    NSLog(@"start user seq...");
    self.userSequenceIndex = 0;
    
//    [self.dynamicChannels removeAllObjects];
//    [self.hits removeAllObjects];
    
//    for (TickChannel *channel in self.channels) {
//        [channel reset];
//    }
    
    [self schedule:@selector(stepUserSequence:) interval:kSequenceInterval];
}

- (void)stopUserSequence
{
    NSLog(@"stop user seq...");
    [self unschedule:@selector(stepUserSequence:)];
    
    //    NSMutableSet *channels = [NSMutableSet set];
    //    NSSet *tickChannels = [self.channels setByAddingObjectsFromSet:self.dynamicChannels];
    //    for (TickChannel *ch in tickChannels) {
    //        [channels addObject:ch.channel];
    //    }
    //    [self stopAudioForChannels:channels];
}

- (void)startSolutionSequence
{
    NSLog(@"start sol seq...");
    self.solutionSequenceIndex = 0;
//    [self.solutionChannels removeAllObjects];
    [self schedule:@selector(stepSolutionSequence) interval:kSequenceInterval];
}

- (void)stopSolutionSequence
{
    NSLog(@"stop sol seq...");
    [self unschedule:@selector(stepSolutionSequence)];
}

- (void)playSolutionIndex:(NSInteger)index
{
    NSLog(@"play sol index: %i", index);
//    if ((index >= self.solutionSequence.sequence.count) || (index < 0)) {
//        NSLog(@"warning: index out of TickDispatcher range");
//        return;
//    }
//    
//    NSArray *events = [self.solutionSequence.sequence objectAtIndex:index];
//    [[MainSynth sharedMainSynth] receiveEvents:events ignoreAudioPad:YES];
//    
//    for (TickEvent *event in events) {
//        [self.solutionChannels addObject:event.channel];
//    }
}


#pragma mark - Other sequence stuff

- (void)addAudioResponder:(id<AudioResponder>)responder
{
    [self.responders addObject:responder];
}

//- (void)stopAudioForChannels:(NSSet *)channels
//{
//    NSMutableArray *combined = [NSMutableArray array];
//    for (NSString *channel in channels) {
//        AudioStopEvent *audioStop = [[AudioStopEvent alloc] initWithChannel:channel isAudioEvent:YES];
//        [combined addObject:audioStop];
//    }
//    [[MainSynth sharedMainSynth] receiveEvents:combined ignoreAudioPad:YES];
//}

- (void)stepUserSequence:(ccTime)dt
{
    NSLog(@"step user seq...");
}

- (void)stepSolutionSequence
{
    NSLog(@"step sol seq...");
//    if (self.sequenceIndex >= self.sequenceLength) {
//        [self unschedule:@selector(advanceSequence)];
//        [self stopAudioForChannels:self.solutionChannels];
//        return;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAdvancedSequence object:nil userInfo:@{kKeySequenceIndex:@(self.sequenceIndex)}];
//    [self play:self.sequenceIndex];
//    self.sequenceIndex++;
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

//#pragma mark - TickDispatcherDelegate
//
//- (void)tickExit:(Coord *)cell
//{
////    // create the exit animation -- don't send an event to synth, TickDispatcher handles in this case
////    [self addChild:[SequenceLayer exitFader:cell]];
//}
//
//- (void)win
//{
//    [self.backgroundLayer tintToColor:ccGREEN duration:kTickInterval];
//}

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
    NSLog(@"\n\n--debug------------------------");
    NSLog(@"seq layer content size: %@", NSStringFromCGSize(self.contentSize));
    NSLog(@"seq layer bounding box: %@", NSStringFromCGRect(self.boundingBox));
    NSLog(@"seq layer position: %@", NSStringFromCGPoint(self.position));
    NSLog(@"seq layer scale: %g", self.scale);
    NSLog(@"--end debug------------------------\n");
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
