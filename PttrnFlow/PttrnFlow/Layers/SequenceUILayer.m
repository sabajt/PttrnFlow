//
//  SequenceUILayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "SequenceUILayer.h"
#import "TickerControl.h"
#import "TickHitChart.h"
#import "TickDispatcher.h"
#import "CCSprite+Utils.h"
#import "DragButton.h"
#import "TextureUtils.h"
#import "PanSprite.h"
#import "ColorUtils.h"
#import "TileSprite.h"
#import "ClippingSprite.h"
#import "TBSpriteMask.h"
#import "PathUtils.h"

static int const kMaxControlLengthFull = 8;
static int const kMaxControlLengthCompact = 6;
static CGFloat const kTimelineStepWidth = 40;
static CGFloat const kTimeLineRowHeight = 44;
static CGFloat const kControlsRowHeight = 80; // use as bottom of timeline background image asset offset
static CGFloat const kControlsButtonWidth = 320 / 4;
static CGFloat const kItemMenuBottom = 80;
static CGFloat const kUIPadding = 4;
static CGFloat const kLineWidth = 2;
static CGFloat const kItemMenuRowHeight = 80;
static GLubyte const kPanelMaskOpacity = 255;

@interface SequenceUILayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (weak, nonatomic) CCSpriteBatchNode *uiBatchNode;

// size and positions
@property (assign) int steps;
@property (assign) BOOL menuOpen;
@property (assign) CGFloat itemsToggleOpenX;
@property (assign) CGSize buttonAssetSize;

// timeline controls
@property (weak, nonatomic) PanSprite *panSprite;
@property (weak, nonatomic) CCSprite *timelineBorder;
@property (weak, nonatomic) CCSprite *timelineBackground;
@property (weak, nonatomic) TickHitChart *hitChart;
@property (weak, nonatomic) TickerControl *tickerControl;

// item menu
@property (weak, nonatomic) CCSprite *itemMenuTopCap;
@property (weak, nonatomic) CCSprite *itemMenuBottomCap;
@property (weak, nonatomic) TileSprite *itemMenuLeftSeparator;
@property (weak, nonatomic) ClippingSprite *rightGradientMask;
@property (weak, nonatomic) CCMenuItemToggle *itemsToggle;
@property (strong, nonatomic) NSMutableArray *dragButtons;

// general controls
@property (weak, nonatomic) CCMenu *controlMenu;

@end

@implementation SequenceUILayer

- (id)initWithPuzzle:(NSUInteger)puzzle tickDispatcher:(TickDispatcher *)tickDispatcher dragItemDelegate:(id<DragItemDelegate>)dragItemDelegate
{
    self = [super init];
    if (self) {
        _tickDispatcher = tickDispatcher;

        // set general sizes / positions
        CCSprite *itemMenuBottomCap = [CCSprite spriteWithSpriteFrameName:@"item_menu_bottom.png"];
        static CGFloat itemsToggleOpenOffset = 10;
        _itemsToggleOpenX = (self.contentSize.width - itemMenuBottomCap.contentSize.width) - itemsToggleOpenOffset;
        CCSprite *exitOff = [CCSprite spriteWithSpriteFrameName:@"exit_off.png"];
        _buttonAssetSize = exitOff.contentSize;
        
        // batch node
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        self.uiBatchNode = uiBatch;
        
        // bottom controls mask
        CCSprite *bottomControlsMask = [CCSprite spriteWithSpriteFrameName:@"bottom_controls_mask.png"];
        bottomControlsMask.anchorPoint = ccp(0, 0);
        bottomControlsMask.position = ccp(0, 0);
        [self addChild:bottomControlsMask]; // can't add to batch because must be drawn below menu items
        
        // exit button bottom left
        CCSprite *exitOn = [CCSprite spriteWithSpriteFrameName:@"exit_on.png"];
        CCMenuItemSprite *exitButton = [[CCMenuItemSprite alloc] initWithNormalSprite:exitOff selectedSprite:exitOn disabledSprite:nil target:self selector:@selector(exitPressed:)];
        exitButton.position = ccp(kControlsButtonWidth / 2, kControlsRowHeight / 2);
        
        // speaker button
        CCSprite *speakerOff = [CCSprite spriteWithSpriteFrameName:@"speaker_off.png"];
        CCSprite *speakerOn = [CCSprite spriteWithSpriteFrameName:@"speaker_on.png"];
        CCMenuItemSprite *speakerButton = [[CCMenuItemSprite alloc] initWithNormalSprite:speakerOff selectedSprite:speakerOn disabledSprite:nil target:self selector:@selector(speakerPressed:)];
        speakerButton.position = ccp((3 * kControlsButtonWidth) / 2, kControlsRowHeight / 2);
        
        // play button
        CCSprite *playOff = [CCSprite spriteWithSpriteFrameName:@"play_off.png"];
        CCSprite *playOn = [CCSprite spriteWithSpriteFrameName:@"play_on.png"];
        CCMenuItemSprite *playButton = [[CCMenuItemSprite alloc] initWithNormalSprite:playOff selectedSprite:playOn disabledSprite:nil target:self selector:@selector(playButtonPressed:)];
        playButton.position = ccp((5 * kControlsButtonWidth) / 2, kControlsRowHeight / 2);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:exitButton, speakerButton, playButton, nil];
        _controlMenu = menu;
        menu.position = CGPointZero;
        [self addChild:menu]; // can't add to batch because menu is not a ccsprite
        
        int steps = (tickDispatcher.sequenceLength / 4);
        self.steps = steps;
        TickerControl *tickerControl = [[TickerControl alloc] initWithSpriteFrameName:kClearRectUILayer steps:steps unitSize:CGSizeMake(kTimelineStepWidth, kTimeLineRowHeight)];
        _tickerControl = tickerControl;
        tickerControl.tickerControlDelegate = tickDispatcher;
        tickerControl.position = ccp(tickerControl.contentSize.width / 2, (3 * tickerControl.contentSize.height) / 2);
        
        // hit chart
        TickHitChart *hitChart = [[TickHitChart alloc] initWithSpriteFrameName:kClearRectUILayer steps:steps unitSize:CGSizeMake(kTimelineStepWidth, kTimeLineRowHeight)];
        _hitChart = hitChart;
        hitChart.position = ccp(hitChart.contentSize.width / 2, hitChart.contentSize.height / 2);
        
        // dotted line separator
        TileSprite *dotSeparator = [[TileSprite alloc] initWithTileFrameName:@"dotted_line_40_2.png" repeatHorizonal:steps repeatVertical:1];
        dotSeparator.position = ccp(dotSeparator.contentSize.width / 2, kTimeLineRowHeight);
        
        // pan sprite
        CGFloat panNodeWidth = MIN(steps, kMaxControlLengthFull) * kTimelineStepWidth;
        CGSize panNodeSize = CGSizeMake(panNodeWidth, 2 * kTimeLineRowHeight);
        CGSize scrollingContainerSize = CGSizeMake(steps * kTimelineStepWidth, panNodeSize.height);
        CGPoint panNodeOrigin = ccp(0, kControlsRowHeight);
        PanSprite *panSprite = [[PanSprite alloc] initWithSpriteFrameName:kClearRectUILayer contentSize:panNodeSize scrollingSize:scrollingContainerSize scrollSprites:@[hitChart, tickerControl, dotSeparator]];
        _panSprite = panSprite;
        panSprite.scrollDirection = ScrollDirectionHorizontal;
        panSprite.position = panNodeOrigin;
        [self addChild:panSprite]; // can't add to batch because PanSprite contains ClippingSprite which overrides 'visit'
        
        // timeline controls border
        CCSprite *timelineBorder = [CCSprite spriteWithSpriteFrameName:@"control_bar.png"];
        _timelineBorder = timelineBorder;
        timelineBorder.anchorPoint = CGPointZero;
        [uiBatch addChild:timelineBorder];
        
        // timeline controls background
        CCSprite *timelineBackground = [CCSprite spriteWithSpriteFrameName:@"control_bar_gradient_mask.png"];
        _timelineBackground = timelineBackground;
        timelineBackground.anchorPoint = CGPointZero;
        timelineBackground.opacity = kPanelMaskOpacity;
        [self addChild:timelineBackground z:self.panSprite.zOrder - 1]; // can't add to batch because must be drawn below pan sprite
        
        // add ui batch at top
        [self addChild:uiBatch];
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    // set control menu to receive touches below everything (so won't overlap pan sprte)
    [self.controlMenu setHandlerPriority:INT_MAX - 1];
}

- (void)exitPressed:(id)sender
{
    [[CCDirector sharedDirector] popScene];
}

- (void)speakerPressed:(id)sender
{
    [self.tickDispatcher scheduleSequence];
}

- (void)playButtonPressed:(id)sender
{
    [self.hitChart resetCells];
    [self.tickDispatcher start];
}

@end
