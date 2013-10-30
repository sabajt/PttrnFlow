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

static int const kMaxControlLengthFull = 8;
static int const kMaxControlLengthCompact = 6;
static CGFloat const kControlStepWidth = 40;
static CGFloat const kRowHeight = 44;

@interface SequenceUILayer ()

@property (assign) int steps;
@property (assign) BOOL menuOpen;

@property (weak, nonatomic) TickDispatcher *tickDispatcher;

@property (weak, nonatomic) CCSpriteBatchNode *uiBatchNode;

@property (weak, nonatomic) PanSprite *panSprite;
@property (weak, nonatomic) CCSprite *controlBar;
@property (weak, nonatomic) TickHitChart *hitChart;

@end

@implementation SequenceUILayer

- (id)initWithTickDispatcher:(TickDispatcher *)tickDispatcher dragItems:(NSArray *)dragItems dragItemDelegate:(id<DragItemDelegate>)dragItemDelegate
{
    self = [super init];
    if (self) {
        _tickDispatcher = tickDispatcher;

        // general sizes / positions
        CGSize buttonSize = CGSizeMake(80, kRowHeight);
        CGSize controlUnitSize = CGSizeMake(kControlStepWidth, kRowHeight);
        CGFloat yMidRow1 = self.contentSize.height - (kRowHeight / 2);
        CGFloat yMidRow2 = self.contentSize.height - ((3 * kRowHeight) / 2);
        CGFloat yMidRow3 = self.contentSize.height - ((5 * kRowHeight) / 2);
        CGFloat controlBarBottom = self.contentSize.height - (3 * kRowHeight);
        
        // batch node
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        self.uiBatchNode = uiBatch;
        [self addChild:uiBatch];
        
        // exit button top left
        CCSprite *exitOff = [CCSprite spriteWithSpriteFrameName:@"exit_off.png"];
        CCSprite *exitOn = [CCSprite spriteWithSpriteFrameName:@"exit_on.png"];
        CCMenuItemSprite *exitButton = [[CCMenuItemSprite alloc] initWithNormalSprite:exitOff selectedSprite:exitOn disabledSprite:nil target:self selector:@selector(exitPressed:)];
        exitButton.position = ccp(buttonSize.width / 2, yMidRow1);
        
        // speaker button
        CCSprite *speakerOff = [CCSprite spriteWithSpriteFrameName:@"speaker_off.png"];
        CCSprite *speakerOn = [CCSprite spriteWithSpriteFrameName:@"speaker_on.png"];
        CCMenuItemSprite *speakerButton = [[CCMenuItemSprite alloc] initWithNormalSprite:speakerOff selectedSprite:speakerOn disabledSprite:nil target:self selector:@selector(speakerPressed:)];
        speakerButton.position = ccp((3 * buttonSize.width) / 2, yMidRow1);
        
        // play button
        CCSprite *playOff = [CCSprite spriteWithSpriteFrameName:@"play_off.png"];
        CCSprite *playOn = [CCSprite spriteWithSpriteFrameName:@"play_on.png"];
        CCMenuItemSprite *playButton = [[CCMenuItemSprite alloc] initWithNormalSprite:playOff selectedSprite:playOn disabledSprite:nil target:self selector:@selector(playButtonPressed:)];
        playButton.position = ccp((5 * buttonSize.width) / 2, yMidRow1);
        
        // hamburger button (drop down menu) top right
        CCSprite *hamburgerOff1 = [CCSprite spriteWithSpriteFrameName:@"hamburger_off.png"];
        CCSprite *hamburgerOn1 = [CCSprite spriteWithSpriteFrameName:@"hamburger_on.png"];
        CCMenuItemSprite *hamburgerOffItem = [CCMenuItemSprite itemWithNormalSprite:hamburgerOff1 selectedSprite:hamburgerOn1];
        
        CCSprite *hamburgerOff2 = [CCSprite spriteWithSpriteFrameName:@"hamburger_off.png"];
        CCSprite *hamburgerOn2 = [CCSprite spriteWithSpriteFrameName:@"hamburger_on.png"];
        CCMenuItemSprite *hamburgerOnItem = [CCMenuItemSprite itemWithNormalSprite:hamburgerOn2 selectedSprite:hamburgerOff2];
        CCMenuItemToggle *hamburgerToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(hamburgerButtonPressed:) items:hamburgerOffItem, hamburgerOnItem, nil];
        hamburgerToggle.position = ccp((7 * buttonSize.width) / 2, yMidRow1);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:exitButton, speakerButton, playButton, hamburgerToggle, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
        
        // ticker control
        int steps = (tickDispatcher.sequenceLength / 4);
        self.steps = steps;
        TickerControl *tickerControl = [[TickerControl alloc] initWithSpriteFrameName:@"clear_rect_uilayer.png" steps:steps unitSize:controlUnitSize];
        tickerControl.tickerControlDelegate = tickDispatcher;
        tickerControl.position = ccp(tickerControl.contentSize.width / 2, (3 * tickerControl.contentSize.height) / 2);
        
        // hit chart
        TickHitChart *hitChart = [[TickHitChart alloc] initWithSpriteFrameName:@"clear_rect_uilayer.png" steps:steps unitSize:controlUnitSize];
        _hitChart = hitChart;
        hitChart.position = ccp(hitChart.contentSize.width / 2, hitChart.contentSize.height / 2);
        
        // pan sprite
        CGFloat panNodeWidth = MIN(steps, kMaxControlLengthFull) * controlUnitSize.width;
        CGSize panNodeSize = CGSizeMake(panNodeWidth, 2 * controlUnitSize.height);
        CGSize scrollingContainerSize = CGSizeMake(steps * controlUnitSize.width, panNodeSize.height);
        CGPoint panNodeOrigin = ccp(0, controlBarBottom);
        PanSprite *panSprite = [[PanSprite alloc] initWithSpriteFrameName:@"clear_rect_uilayer.png" contentSize:panNodeSize scrollingSize:scrollingContainerSize scrollSprites:@[hitChart, tickerControl]];
        _panSprite = panSprite;
        panSprite.scrollDirection = ScrollDirectionHorizontal;
        panSprite.position = panNodeOrigin;
        [self addChild:panSprite];
        
        // control bar separator
        CCSprite *controlBar = [CCSprite spriteWithSpriteFrameName:@"control_bar.png"];
        _controlBar = controlBar;
        controlBar.anchorPoint = ccp(0, 0);
        [uiBatch addChild:controlBar];
        
        // size and position the pan sprite and control bar
        [self configureControlsCompact:NO animated:NO];
        _menuOpen = NO;
        
//        // drag items
//        int i = 0;
//        for (NSNumber *item in dragItems) {
//            
//            kDragItem itemType = [item intValue];
//            DragButton *button = [[DragButton alloc] initWithItemType:itemType delegate:dragItemDelegate];
//            
//            CGFloat yOffset = (topBarHeight + (button.contentSize.height * (i + 1)));
//            CGFloat yPos = self.contentSize.height - yOffset;
//            button.position = ccp(self.contentSize.width - button.contentSize.width, yPos);
//            
//            [self addChild:button];
//            i++;
//        }
    }
    return self;
}

- (void)configureControlsCompact:(BOOL)compact animated:(BOOL)animated
{
    int unitWidth;
    if (compact) {
        unitWidth = MIN(self.steps, kMaxControlLengthCompact);
    }
    else {
        unitWidth = MIN(self.steps, kMaxControlLengthFull);
    }
    
    // control bar
    CGFloat xOffset = -(kMaxControlLengthFull - unitWidth) * kControlStepWidth;
    if (xOffset < 0){
        xOffset -= (self.controlBar.contentSize.width - self.contentSize.width);
    }
    CGPoint controlBarPos = ccp(xOffset, self.contentSize.height - (3 * kRowHeight));
    
    // pan sprite
    CGFloat panNodeWidth = unitWidth * kControlStepWidth;
    
    // animate
    if (animated) {
        CCMoveTo *moveControlBar = [CCMoveTo actionWithDuration:kTransitionDuration position:controlBarPos];
        CCActionTween *changeWidth = [CCActionTween actionWithDuration:kTransitionDuration key:@"containerWidth" from:self.panSprite.contentSize.width to:panNodeWidth];
        
        [self.controlBar runAction:moveControlBar];
        [self.panSprite runAction:changeWidth];
    }
    // jump to
    else {
        self.controlBar.position = controlBarPos;
        self.panSprite.containerWidth = panNodeWidth;
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

- (void)hamburgerButtonPressed:(id)sender
{
    self.menuOpen = !self.menuOpen;
    [self configureControlsCompact:self.menuOpen animated:YES];
}


@end
