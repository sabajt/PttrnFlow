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
#import "PuzzleUtils.h"

CGFloat const kUIButtonUnitSize = 50;
CGFloat const kUITimelineStepWidth = 40;
CGFloat const kUILineWidth = 2;

static NSInteger const kMaxControlLength = 7;

@interface SequenceUILayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (weak, nonatomic) CCSpriteBatchNode *uiBatchNode;

// size and positions
@property (assign) NSInteger steps;
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
        NSInteger steps = (tickDispatcher.sequenceLength / 4);
        self.steps = steps;

        // set general sizes / positions
        CCSprite *exitOff = [CCSprite spriteWithSpriteFrameName:@"exit_off.png"];
        _buttonAssetSize = exitOff.contentSize;
        
        // batch node
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        self.uiBatchNode = uiBatch;
        
        // right controls panel
        CCSprite *rightControlsPanel = [CCSprite spriteWithSpriteFrameName:@"controls_panel_right.png"];
        rightControlsPanel.anchorPoint = ccp(0, 0);
        
        if (steps > kMaxControlLength) {
            rightControlsPanel.position = ccp(10, 0);
        }
        else {
            rightControlsPanel.position = ccp(((kUIButtonUnitSize - kUITimelineStepWidth) + kUILineWidth) - (kUITimelineStepWidth * (kMaxControlLength - steps)), 0);
        }
        
        [self.uiBatchNode addChild:rightControlsPanel];
        
        // left controls panel
        CCSprite *leftControlsPanel = [CCSprite spriteWithSpriteFrameName:@"controls_panel_left.png"];
        leftControlsPanel.anchorPoint = ccp(0, 0);
        leftControlsPanel.position = ccp(0, 0);
        [self.uiBatchNode addChild:leftControlsPanel];
        
        // top left controls panel
        CCSprite *topLeftControlsPanel = [CCSprite spriteWithSpriteFrameName:@"controls_panel_top_left.png"];
        topLeftControlsPanel.anchorPoint = ccp(0, 1);
        topLeftControlsPanel.position = ccp(0, self.contentSize.height);
        [self.uiBatchNode addChild:topLeftControlsPanel];
        
        // add ui batch below buttons (ccmenu not compatible with batch) and pan sprite (clipping using glscissor also not compatible with batch)
        [self addChild:uiBatch];
        
        // exit button top left
        CCSprite *exitOn = [CCSprite spriteWithSpriteFrameName:@"exit_on.png"];
        CCMenuItemSprite *exitButton = [[CCMenuItemSprite alloc] initWithNormalSprite:exitOff selectedSprite:exitOn disabledSprite:nil target:self selector:@selector(exitPressed:)];
        exitButton.position = ccp(kUIButtonUnitSize / 2, self.contentSize.height - (kUIButtonUnitSize / 2));
        
        // speaker button
        CCSprite *speakerOff = [CCSprite spriteWithSpriteFrameName:@"speaker_off.png"];
        CCSprite *speakerOn = [CCSprite spriteWithSpriteFrameName:@"speaker_on.png"];
        CCMenuItemSprite *speakerButton = [[CCMenuItemSprite alloc] initWithNormalSprite:speakerOff selectedSprite:speakerOn disabledSprite:nil target:self selector:@selector(speakerPressed:)];
        speakerButton.position = ccp(kUIButtonUnitSize / 2, (3 * kUIButtonUnitSize) / 2);
        
        // play button
        CCSprite *playOff = [CCSprite spriteWithSpriteFrameName:@"play_off.png"];
        CCSprite *playOn = [CCSprite spriteWithSpriteFrameName:@"play_on.png"];
        CCMenuItemSprite *playButton = [[CCMenuItemSprite alloc] initWithNormalSprite:playOff selectedSprite:playOn disabledSprite:nil target:self selector:@selector(playButtonPressed:)];
        playButton.position = ccp(kUIButtonUnitSize / 2, kUIButtonUnitSize / 2);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:exitButton, speakerButton, playButton, nil];
        _controlMenu = menu;
        menu.position = CGPointZero;
        [self addChild:menu]; // can't add to batch because menu is not a ccsprite
        
        TickerControl *tickerControl = [[TickerControl alloc] initWithSpriteFrameName:kClearRectUILayer steps:steps unitSize:CGSizeMake(kUITimelineStepWidth, kUIButtonUnitSize)];
        _tickerControl = tickerControl;
        tickerControl.tickerControlDelegate = tickDispatcher;
        tickerControl.position = ccp(tickerControl.contentSize.width / 2, (3 * tickerControl.contentSize.height) / 2);
        
        // hit chart
        TickHitChart *hitChart = [[TickHitChart alloc] initWithSpriteFrameName:kClearRectUILayer steps:steps unitSize:CGSizeMake(kUITimelineStepWidth, kUIButtonUnitSize)];
        _hitChart = hitChart;
        hitChart.position = ccp(hitChart.contentSize.width / 2, hitChart.contentSize.height / 2);
        
        // dotted line separator
        TileSprite *dotSeparator = [[TileSprite alloc] initWithTileFrameName:@"dotted_line_40_2.png" repeatHorizonal:steps repeatVertical:1];
        dotSeparator.position = ccp(dotSeparator.contentSize.width / 2, kUIButtonUnitSize);
        
        // pan sprite
        CGFloat panNodeWidth = MIN(steps, kMaxControlLength) * kUITimelineStepWidth;
        CGSize panNodeSize = CGSizeMake(panNodeWidth, 2 * kUIButtonUnitSize);
        CGSize scrollingContainerSize = CGSizeMake(steps * kUITimelineStepWidth, panNodeSize.height);
        CGPoint panNodeOrigin = ccp(kUIButtonUnitSize, 0);
        PanSprite *panSprite = [[PanSprite alloc] initWithSpriteFrameName:kClearRectUILayer contentSize:panNodeSize scrollingSize:scrollingContainerSize scrollSprites:@[hitChart, tickerControl, dotSeparator]];
        _panSprite = panSprite;
        panSprite.scrollDirection = ScrollDirectionHorizontal;
        panSprite.position = panNodeOrigin;
        [self addChild:panSprite]; // can't add to batch because PanSprite contains ClippingSprite which overrides 'visit'
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
