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
        
        // toolbox (item menu) button
        CCSprite *itemsButtonOff1 = [CCSprite spriteWithSpriteFrameName:@"toolbox_off.png"];
        CCSprite *itemsButtonOn1 = [CCSprite spriteWithSpriteFrameName:@"toolbox_on.png"];
        CCMenuItemSprite *itemsButtonOffItem = [CCMenuItemSprite itemWithNormalSprite:itemsButtonOff1 selectedSprite:itemsButtonOn1];
        CCSprite *itemsButtonOff2 = [CCSprite spriteWithSpriteFrameName:@"toolbox_off.png"];
        CCSprite *itemsButtonOn2 = [CCSprite spriteWithSpriteFrameName:@"toolbox_on.png"];
        CCMenuItemSprite *itemsButtonOnItem = [CCMenuItemSprite itemWithNormalSprite:itemsButtonOn2 selectedSprite:itemsButtonOff2];
        
        CCMenuItemToggle *itemsToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(itemsButtonPressed:) items:itemsButtonOffItem, itemsButtonOnItem, nil];
        _itemsToggle = itemsToggle;
        _itemsToggle.position = ccp((7 * kControlsButtonWidth) / 2, kControlsRowHeight / 2);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:exitButton, speakerButton, playButton, itemsToggle, nil];
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
        
        // item menu
        NSDictionary *inventory = [PathUtils puzzleInventory:puzzle];
        
        // -- edges
        _itemMenuBottomCap = itemMenuBottomCap;
        itemMenuBottomCap.anchorPoint = CGPointZero;
        itemMenuBottomCap.position = ccp([self itemMenuLeftOpened:NO], kItemMenuBottom);
        [uiBatch addChild:itemMenuBottomCap];
        
        TileSprite *itemMenuLeftSeparator = [[TileSprite alloc] initWithTileFrameName:@"dotted_line_2_80.png" repeatHorizonal:1 repeatVertical:inventory.count];
        _itemMenuLeftSeparator = itemMenuLeftSeparator;
        itemMenuLeftSeparator.anchorPoint = CGPointZero;
        itemMenuLeftSeparator.position = ccp([self itemMenuLeftOpened:NO], self.itemMenuBottomCap.position.y + self.itemMenuBottomCap.contentSize.height);
        [uiBatch addChild:itemMenuLeftSeparator];
        
        CCSprite *itemMenuTopCap = [CCSprite spriteWithSpriteFrameName:@"item_menu_top.png"];
        _itemMenuTopCap = itemMenuTopCap;
        itemMenuTopCap.anchorPoint = CGPointZero;
        itemMenuTopCap.position = ccp([self itemMenuLeftOpened:NO], self.itemMenuLeftSeparator.position.y + self.itemMenuLeftSeparator.contentSize.height);
        [uiBatch addChild:itemMenuTopCap];
        
        // -- panel mask
        CGFloat maskHeight = itemMenuTopCap.position.y - (kItemMenuBottom + itemMenuBottomCap.contentSize.height);
        ClippingSprite *rightGradientMask = [ClippingSprite clippingSpriteWithRect:CGRectMake(0, 0, self.itemMenuBottomCap.contentSize.width, maskHeight)];
        _rightGradientMask = rightGradientMask;
        rightGradientMask.anchorPoint = CGPointZero;
        rightGradientMask.position = [self itemMenuOriginOpened:NO];
        
        CCSprite *rightGradientSprite = [CCSprite spriteWithSpriteFrameName:@"gradient_mask_76_568.png"];
        rightGradientSprite.anchorPoint = CGPointZero;
        rightGradientSprite.position = ccp(0, -(kItemMenuBottom + itemMenuBottomCap.contentSize.height));
        rightGradientSprite.opacity = kPanelMaskOpacity;
        [rightGradientMask addChild:rightGradientSprite];
        [self addChild:rightGradientMask]; // can't add to batch because
        
        // drag items
        _dragButtons = [NSMutableArray array];
        int i = 0;
        [inventory enumerateKeysAndObjectsUsingBlock:^(NSString *itemKey, NSNumber *number, BOOL *stop) {
            DragButton *button = [[DragButton alloc] initWithItemKey:itemKey delegate:dragItemDelegate];
            button.anchorPoint = CGPointZero;
            [self addChild:button];
            [self.dragButtons addObject:button];
            button.position = [self dragButtonPosition:i opened:NO];
        }];

        // size and position the pan sprite and control bar
        [self configureItemMenuOpened:NO animated:NO];
        _menuOpen = NO;
        
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

// assumes contentSize, itemMenuBottomCap and timelineBorder are already setup
- (CGFloat)itemMenuLeftOpened:(BOOL)opened
{
    static CGFloat padding = 4;
    if (opened) {
        return self.contentSize.width - self.itemMenuBottomCap.contentSize.width;
    }
    return self.contentSize.width + (self.timelineBorder.contentSize.width - self.contentSize.width) + padding;
}

// assumes contentSize, itemMenuBottomCap and timelineBorder are already setup
- (CGPoint)itemMenuOriginOpened:(BOOL)opened
{
    return ccp([self itemMenuLeftOpened:opened], kItemMenuBottom + self.itemMenuBottomCap.contentSize.height);
}

// assumes drag button at index, contentSize, itemMenuBottomCap and timelineBorder are already setup
- (CGPoint)dragButtonPosition:(NSUInteger)index opened:(BOOL)opened
{
    CGPoint menuOrigin = [self itemMenuOriginOpened:opened];
    DragButton *button = self.dragButtons[index];
    return ccp(menuOrigin.x, menuOrigin.y + (index * button.contentSize.height));
}

- (void)configureItemMenuOpened:(BOOL)opened animated:(BOOL)animated
{
    int unitWidth = MIN(self.steps, kMaxControlLengthFull);
    if (opened) {
        unitWidth = MIN(self.steps, kMaxControlLengthCompact);
    }
    
    // timeline
    CGFloat xOffset = -(kMaxControlLengthFull - unitWidth) * kTimelineStepWidth;
    if (xOffset < 0){
        xOffset -= (self.timelineBorder.contentSize.width - self.contentSize.width);
        if (unitWidth == kMaxControlLengthCompact) {
            xOffset -= kUIPadding;
        }
    }
    CGPoint timelinePos = ccp(xOffset, kControlsRowHeight);
    
    // pan sprite
    CGFloat panSpriteWidth;
    if ( xOffset < 0) {
        panSpriteWidth = (unitWidth * kTimelineStepWidth);
        if (unitWidth == kMaxControlLengthCompact) {
            panSpriteWidth -= (kUIPadding + kLineWidth);
        }
    }
    else {
        panSpriteWidth = (unitWidth * kTimelineStepWidth);
    }
    
    // item menu
    CGPoint itemMenuBottomCapPos = ccp([self itemMenuLeftOpened:opened], kItemMenuBottom);
    CGPoint itemMenuLeftSeparatorPos = ccp([self itemMenuLeftOpened:opened], self.itemMenuBottomCap.position.y + self.itemMenuBottomCap.contentSize.height);
    CGPoint itemMenuTopCapPos = ccp([self itemMenuLeftOpened:opened], self.itemMenuLeftSeparator.position.y + self.itemMenuLeftSeparator.contentSize.height);
    
    // animate
    if (animated) {
        // timeline border
        CCMoveTo *moveTimelineBorder = [CCMoveTo actionWithDuration:kTransitionDuration position:timelinePos];
        CCEaseSineOut *easeTimelineBorder = [CCEaseSineOut actionWithAction:moveTimelineBorder];
        [self.timelineBorder runAction:easeTimelineBorder];
        
        // timeline background
        CCMoveTo *moveTimelineBackgroud = [CCMoveTo actionWithDuration:kTransitionDuration position:timelinePos];
        CCEaseSineOut *easeTimelineBackground = [CCEaseSineOut actionWithAction:moveTimelineBackgroud];
        [self.timelineBackground runAction:easeTimelineBackground];

        // pan sprite with completion
        CCActionTween *changeWidth = [CCActionTween actionWithDuration:kTransitionDuration key:@"containerWidth" from:self.panSprite.contentSize.width to:panSpriteWidth];
        CCEaseSineOut *easePanSprite = [CCEaseSineOut actionWithAction:changeWidth];
        CCCallBlock *completion = [CCCallBlock actionWithBlock:^{
            [self unscheduleUpdate];
        }];
        CCSequence *panSequence = [CCSequence actionWithArray:@[easePanSprite, completion]];
        [self.panSprite runAction:panSequence];
        
        // item menu
        CCMoveTo *moveItemMenuBottomCap = [CCMoveTo actionWithDuration:kTransitionDuration position:itemMenuBottomCapPos];
        CCEaseSineOut *easeItemMenuBottomCap = [CCEaseSineOut actionWithAction:moveItemMenuBottomCap];
        [self.itemMenuBottomCap runAction:easeItemMenuBottomCap];
        
        CCMoveTo *moveItemMenuLeftSeparator = [CCMoveTo actionWithDuration:kTransitionDuration position:itemMenuLeftSeparatorPos];
        CCEaseSineOut *easeItemMenuLeftSeparator = [CCEaseSineOut actionWithAction:moveItemMenuLeftSeparator];
        [self.itemMenuLeftSeparator runAction:easeItemMenuLeftSeparator];
        
        CCMoveTo *moveItemMenuTopCap = [CCMoveTo actionWithDuration:kTransitionDuration position:itemMenuTopCapPos];
        CCEaseSineOut *easeItemMenuTopCap = [CCEaseSineOut actionWithAction:moveItemMenuTopCap];
        [self.itemMenuTopCap runAction:easeItemMenuTopCap];
        
        // gradient mask
        CCMoveTo *moveMenuMask = [CCMoveTo actionWithDuration:kTransitionDuration position:[self itemMenuOriginOpened:opened]];
        CCEaseSineOut *easeMenuMask = [CCEaseSineOut actionWithAction:moveMenuMask];
        [self.rightGradientMask runAction:easeMenuMask];
        
        // item buttons
        NSUInteger i = 0;
        for (DragButton *button in self.dragButtons) {
            CCMoveTo *moveDragButton = [CCMoveTo actionWithDuration:kTransitionDuration position:[self dragButtonPosition:i opened:opened]];
            CCEaseSineOut *easeDragButton = [CCEaseSineOut actionWithAction:moveDragButton];
            [button runAction:easeDragButton];
            i++;
        }
        
        // update callback for pan node interior tracking
        [self scheduleUpdate];
    }
    // jump to
    else {
        self.timelineBorder.position = timelinePos;
        self.timelineBackground.position = timelinePos;
        self.panSprite.containerWidth = panSpriteWidth;
        self.itemMenuBottomCap.position = itemMenuBottomCapPos;
        self.itemMenuLeftSeparator.position = itemMenuLeftSeparatorPos;
        self.itemMenuTopCap.position = itemMenuTopCapPos;
        self.rightGradientMask.position = [self itemMenuOriginOpened:opened];
        
        // item buttons
        NSUInteger i = 0;
        for (DragButton *button in self.dragButtons) {
            button.position = [self dragButtonPosition:i opened:opened];
            i++;
        }
    }
}

// scheduled when menu is opening
- (void)update:(ccTime)deltaTime
{
    if (!self.menuOpen) {
        // track and move pan sprite's scroll surface if needed
        if (self.panSprite.containerWidth > [self.panSprite scrollSurfaceRight]) {
            CGFloat dx = self.panSprite.containerWidth - [self.panSprite scrollSurfaceRight];
            self.panSprite.scrollSurface.position = ccp(self.panSprite.scrollSurface.position.x + dx, self.panSprite.scrollSurface.position.y);
        }
    }
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

- (void)itemsButtonPressed:(id)sender
{
    self.menuOpen = !self.menuOpen;
    [self configureItemMenuOpened:self.menuOpen animated:YES];
}

@end
