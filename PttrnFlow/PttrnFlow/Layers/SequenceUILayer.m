//
//  SequenceUILayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "SequenceUILayer.h"
#import "TickDispatcher.h"
#import "CCSprite+Utils.h"
#import "TextureUtils.h"
#import "PanSprite.h"
#import "ColorUtils.h"
#import "TileSprite.h"
#import "ClippingSprite.h"
#import "PuzzleUtils.h"
#import "SolutionCell.h"

CGFloat const kUIButtonUnitSize = 50;
CGFloat const kUITimelineStepWidth = 40;
CGFloat const kUILineWidth = 2;

static NSInteger const kMaxControlLength = 6;

@interface SequenceUILayer ()

@property (weak, nonatomic) CCSpriteBatchNode *uiBatchNode;
@property (weak, nonatomic) id<PuzzleControlsDelegate> delegate;

// size and positions
@property (assign) NSInteger steps;
@property (assign) BOOL menuOpen;
@property (assign) CGFloat itemsToggleOpenX;
@property (assign) CGSize buttonAssetSize;

// timeline controls
@property (weak, nonatomic) PanSprite *panSprite;
@property (weak, nonatomic) CCSprite *timelineBorder;
@property (weak, nonatomic) CCSprite *timelineBackground;

// item menu
@property (weak, nonatomic) CCSprite *itemMenuTopCap;
@property (weak, nonatomic) CCSprite *itemMenuBottomCap;
@property (weak, nonatomic) TileSprite *itemMenuLeftSeparator;
@property (weak, nonatomic) ClippingSprite *rightGradientMask;
@property (weak, nonatomic) CCMenuItemToggle *itemsToggle;
@property (strong, nonatomic) NSMutableArray *dragButtons;

// general controls
@property (weak, nonatomic) CCMenu *controlMenu;

// buttons
@property (weak, nonatomic) ToggleButton *speakerButton;
@property (weak, nonatomic) ToggleButton *playButton;

@end

@implementation SequenceUILayer

- (id)initWithPuzzle:(NSUInteger)puzzle delegate:(id<PuzzleControlsDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        NSInteger steps = 4;
        self.steps = steps;

        // set general sizes / positions
        CCSprite *exitOff = [CCSprite spriteWithSpriteFrameName:@"exit_off.png"];
        _buttonAssetSize = exitOff.contentSize;
        
        // batch node
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        self.uiBatchNode = uiBatch;
        
        // right controls panel
        CCSprite *rightControlsPanel = [CCSprite spriteWithSpriteFrameName:@"controls_panel_right_bottom.png"];
        rightControlsPanel.anchorPoint = ccp(0, 0);
        
        if (steps >= kMaxControlLength) {
            rightControlsPanel.position = ccp(rightControlsPanel.contentSize.width - self.contentSize.width, 0);
        }
        else {
            CGFloat xOffset = (rightControlsPanel.contentSize.width - self.contentSize.width) + (kUITimelineStepWidth * (kMaxControlLength - steps));
            rightControlsPanel.position = ccp(-xOffset, 0);
        }
        
        [self.uiBatchNode addChild:rightControlsPanel];
        
        // left controls panel
        CCSprite *leftControlsPanel = [CCSprite spriteWithSpriteFrameName:@"controls_panel_left.png"];

        leftControlsPanel.anchorPoint = ccp(0, 0);
        leftControlsPanel.position = ccp(0, -50); // will be 0 for seq > 8 len in future
        [self.uiBatchNode addChild:leftControlsPanel];
        
        // top left controls panel corner
        CCSprite *topLeftControlsPanel = [CCSprite spriteWithSpriteFrameName:@"controls_panel_top_left.png"];
        topLeftControlsPanel.anchorPoint = ccp(0, 1);
        topLeftControlsPanel.position = ccp(0, self.contentSize.height);
        [self.uiBatchNode addChild:topLeftControlsPanel];
        
        // add ui batch below buttons (ccmenu not compatible with batch) and pan sprite (clipping using glscissor also not compatible with batch)
        [self addChild:uiBatch];
        
        // speaker (solution sequence) button
        ToggleButton *speakerButton = [[ToggleButton alloc] initWithPlaceholderFrameName:@"clear_rect_uilayer.png" offFrameName:@"speaker_off.png" onFrameName:@"speaker_on.png" delegate:self];
        self.speakerButton = speakerButton;
        self.speakerButton.position = ccp(kUITimelineStepWidth / 2, 75); // FIX ME LATER
        [self.uiBatchNode addChild:self.speakerButton];
        
        // play (user sequence) button
        ToggleButton *playButton = [[ToggleButton alloc] initWithPlaceholderFrameName:@"clear_rect_uilayer.png" offFrameName:@"play_off.png" onFrameName:@"play_on.png" delegate:self];
        self.playButton = playButton;
        self.playButton.position = ccp(speakerButton.position.x + kUITimelineStepWidth, speakerButton.position.y);
        [self.uiBatchNode addChild:self.playButton];
        
        // exit button top left
        CCSprite *exitOn = [CCSprite spriteWithSpriteFrameName:@"exit_on.png"];
        CCMenuItemSprite *exitButton = [[CCMenuItemSprite alloc] initWithNormalSprite:exitOff selectedSprite:exitOn disabledSprite:nil target:self selector:@selector(exitPressed:)];
        exitButton.position = ccp(kUIButtonUnitSize / 2, self.contentSize.height - (kUIButtonUnitSize / 2));
        
//        // speaker button
//        CCSprite *speakerOff = [CCSprite spriteWithSpriteFrameName:@"speaker_off.png"];
//        CCSprite *speakerOn = [CCSprite spriteWithSpriteFrameName:@"speaker_on.png"];
//        CCMenuItemSprite *speakerButton = [[CCMenuItemSprite alloc] initWithNormalSprite:speakerOff selectedSprite:speakerOn disabledSprite:nil target:self selector:@selector(speakerPressed:)];
//        speakerButton.position = ccp(kUIButtonUnitSize / 2, (3 * kUIButtonUnitSize) / 2);
//        
//        // play button
//        CCSprite *playOff = [CCSprite spriteWithSpriteFrameName:@"play_off.png"];
//        CCSprite *playOn = [CCSprite spriteWithSpriteFrameName:@"play_on.png"];
//        CCMenuItemSprite *playButton = [[CCMenuItemSprite alloc] initWithNormalSprite:playOff selectedSprite:playOn disabledSprite:nil target:self selector:@selector(playButtonPressed:)];
//        playButton.position = ccp(kUIButtonUnitSize / 2, kUIButtonUnitSize / 2);
        
        // buttons must be added to a CCMenu to work
//        CCMenu *menu = [CCMenu menuWithItems:exitButton, speakerButton, playButton, nil];
        CCMenu *menu = [CCMenu menuWithItems:exitButton, nil];
        _controlMenu = menu;
        menu.position = CGPointZero;
        [self addChild:menu]; // can't add to batch because menu is not a ccsprite
        
//        TickerControl *tickerControl = [[TickerControl alloc] initWithSpriteFrameName:kClearRectUILayer steps:steps unitSize:CGSizeMake(kUITimelineStepWidth, kUIButtonUnitSize)];
//        _tickerControl = tickerControl;
//        tickerControl.tickerControlDelegate = tickDispatcher;
//        tickerControl.position = ccp(tickerControl.contentSize.width / 2, (3 * tickerControl.contentSize.height) / 2);
//        
//        // hit chart
//        TickHitChart *hitChart = [[TickHitChart alloc] initWithSpriteFrameName:kClearRectUILayer steps:steps unitSize:CGSizeMake(kUITimelineStepWidth, kUIButtonUnitSize)];
//        _hitChart = hitChart;
//        hitChart.position = ccp(hitChart.contentSize.width / 2, hitChart.contentSize.height / 2);
//        
////        // dotted line separator
////        TileSprite *dotSeparator = [[TileSprite alloc] initWithTileFrameName:@"dotted_line_40_2.png" repeatHorizonal:steps repeatVertical:1];
////        dotSeparator.position = ccp(dotSeparator.contentSize.width / 2, kUIButtonUnitSize);
//        
//        // pan sprite
//        CGFloat panNodeWidth = MIN(steps, kMaxControlLength) * kUITimelineStepWidth;
//        CGSize panNodeSize = CGSizeMake(panNodeWidth, 2 * kUIButtonUnitSize);
//        CGSize scrollingContainerSize = CGSizeMake(steps * kUITimelineStepWidth, panNodeSize.height);
//        CGPoint panNodeOrigin = ccp(kUIButtonUnitSize, 0);
//        PanSprite *panSprite = [[PanSprite alloc] initWithSpriteFrameName:kClearRectUILayer contentSize:panNodeSize scrollingSize:scrollingContainerSize scrollSprites:@[hitChart, tickerControl]];
//        
//        _panSprite = panSprite;
//        panSprite.scrollDirection = ScrollDirectionHorizontal;
//        panSprite.position = panNodeOrigin;
//        [self addChild:panSprite]; // can't add to batch because PanSprite contains ClippingSprite which overrides 'visit'
        
        for (NSInteger i = 0; i < steps; i++) {
            SolutionCell *cell = [[SolutionCell alloc] initWithIndex:i];
            cell.position = ccp((i * kUITimelineStepWidth) + (cell.contentSize.width / 2), cell.contentSize.height / 2);
            [self addChild:cell];
        }
    }
    return self;
}

- (void)exitPressed:(id)sender
{
    [[CCDirector sharedDirector] popScene];
}

#pragma mark - ToggleButtonDelegate

- (void)toggleButtonPressed:(ToggleButton *)sender
{
    if ([sender isEqual:self.speakerButton]) {
        if (self.speakerButton.isOn) {
            [self.delegate startSolutionSequence];
        }
        else {
            [self.delegate stopSolutionSequence];
        }
    }
    else if ([sender isEqual:self.playButton]) {
        if (self.playButton.isOn) {
            [self.delegate startUserSequence];
        }
        else {
            [self.delegate stopUserSequence];
        }
    }
}

@end
