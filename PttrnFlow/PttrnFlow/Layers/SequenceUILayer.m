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
#import "PanNode.h"
#import "ColorUtils.h"

static CGFloat const kHandleHeight = 40;
static int const kMaxControlLength = 6;

@interface SequenceUILayer ()

@property (weak, nonatomic) TickDispatcher *tickDispatcher;
@property (weak, nonatomic) TickHitChart *hitChart;

@property (weak, nonatomic) CCSpriteBatchNode *uiBatchNode;

@end

@implementation SequenceUILayer

- (id)initWithTickDispatcher:(TickDispatcher *)tickDispatcher dragItems:(NSArray *)dragItems dragItemDelegate:(id<DragItemDelegate>)dragItemDelegate
{
    self = [super init];
    if (self) {
        _tickDispatcher = tickDispatcher;
        int numberOfDots = (tickDispatcher.sequenceLength / 4);

        // sizes
        CGFloat topBarHeight = 80.0;
        CGFloat yMidRow1 = self.contentSize.height - (topBarHeight / 4);
        CGFloat yMidRow2 = self.contentSize.height - (3 * topBarHeight / 4);
        CGFloat yMidTopBar = self.contentSize.height - (topBarHeight / 2);
        CGFloat yTopBarBottom = self.contentSize.height - topBarHeight;
        CGSize buttonSize = CGSizeMake(topBarHeight / 2, topBarHeight / 2);
        
        CGFloat panNodeWidth;
        if (numberOfDots > kMaxControlLength) {
            panNodeWidth = kMaxControlLength * buttonSize.width;
        }
        else {
            panNodeWidth = numberOfDots * buttonSize.width;
        }
        
        // batch node
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        self.uiBatchNode = uiBatch;
        
        // background panel
        CGSize backgroundPanelSize = CGSizeMake((2 * buttonSize.width) + panNodeWidth, topBarHeight);
        CCSprite *backgroundPanel = [CCSprite rectSpriteWithSize:backgroundPanelSize color:[ColorUtils skyBlue]];
        backgroundPanel.position = ccp(self.contentSize.width - (backgroundPanelSize.width / 2), yMidTopBar);
        [self addChild:backgroundPanel];
        
        // add batch node above background pannel
        [self addChild:uiBatch];
        
        // exit button
        CCLabelTTF *exitLabel = [CCLabelTTF labelWithString:@"EXIT" fontName:@"Arial Rounded MT Bold" fontSize:14];
        exitLabel.color = [ColorUtils defaultSteel];
        CCMenuItemLabel *exitButton = [[CCMenuItemLabel alloc] initWithLabel:exitLabel target:self selector:@selector(backButtonPressed:)];
        exitButton.position = ccp(self.contentSize.width - (buttonSize.width / 2), yMidRow1);
        
        // hamburger button (drop down menu)
        CCSprite *hamburgerOff = [CCSprite spriteWithSpriteFrameName:@"hamburger_off.png"];
        CCSprite *hamburgerOn = [CCSprite spriteWithSpriteFrameName:@"hamburger_on.png"];
        CCMenuItemSprite *hamburgerButton = [[CCMenuItemSprite alloc] initWithNormalSprite:hamburgerOff selectedSprite:hamburgerOn disabledSprite:nil target:self selector:@selector(hamburgerButtonPressed:)];
        hamburgerButton.position = ccp(exitButton.position.x, yMidRow2);
        
        ///////////////////////////////////////
        // pan node
        CGSize panNodeSize = CGSizeMake(panNodeWidth, topBarHeight);
        CGSize scrollingContainerSize = CGSizeMake(numberOfDots * buttonSize.width, panNodeSize.height);
        CGPoint panNodeOrigin = ccp((self.contentSize.width - buttonSize.width) - panNodeSize.width, yTopBarBottom);
        
        NSMutableArray *scrollingSprites = [NSMutableArray array];
        for (int i = 0; i < numberOfDots; i++) {
            CCSprite *tickDot = [CCSprite spriteWithSpriteFrameName:@"tickdot_off.png"];
            tickDot.position = ccp((i * buttonSize.width) + (buttonSize.width / 2), topBarHeight / 2);
            [scrollingSprites addObject:tickDot];
        }
        
        PanNode *panNode = [[PanNode alloc] initWithBatchNode:uiBatch contentSize:panNodeSize scrollingSize:scrollingContainerSize scrollSprites:[NSArray arrayWithArray:scrollingSprites]];
        panNode.scrollDirection = ScrollDirectionHorizontal;
        panNode.position = panNodeOrigin;
        [self addChild:panNode];
        ///////////////////////////////////////
        
        // pan mask pannels if needed
        if (numberOfDots > kMaxControlLength) {
            CGSize maskPanelSize = CGSizeMake(buttonSize.width, topBarHeight);
            
            CCSprite *leftMask = [CCSprite rectSpriteWithSize:maskPanelSize color:[ColorUtils skyBlue]];
            leftMask.position = ccp(panNodeOrigin.x - (buttonSize.width / 2), yMidTopBar);
            [self addChild:leftMask];
            
            CCSprite *rightMask = [CCSprite rectSpriteWithSize:maskPanelSize color:[ColorUtils skyBlue]];
            rightMask.position = ccp(self.contentSize.width - (buttonSize.width / 2), yMidTopBar);
            [self addChild:rightMask];
        }
        
        // match sequence button
        CCSprite *matchDefault = [CCSprite spriteWithSpriteFrameName:@"speaker_off.png"];
        CCSprite *matchSelected = [CCSprite spriteWithSpriteFrameName:@"speaker_on.png"];
        CCMenuItemSprite *matchButton = [[CCMenuItemSprite alloc] initWithNormalSprite:matchDefault selectedSprite:matchSelected disabledSprite:nil target:self selector:@selector(matchButtonPressed:)];
        matchButton.position = ccp(panNodeOrigin.x - (buttonSize.width / 2), yMidRow1);
        
        // run button
        CCSprite *runDefault = [CCSprite spriteWithSpriteFrameName:@"play_off.png"];
        CCSprite *runSelected = [CCSprite spriteWithSpriteFrameName:@"play_on.png"];
        CCMenuItemSprite *runButton = [[CCMenuItemSprite alloc] initWithNormalSprite:runDefault selectedSprite:runSelected disabledSprite:nil target:self selector:@selector(runButtonPressed:)];
        runButton.position = ccp(matchButton.position.x, yMidRow2);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:exitButton, hamburgerButton, matchButton, runButton, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
        
//        // control separators
//        CCSprite *separatorLeft = [CCSprite spriteWithSpriteFrameName:@"control_separator.png"];
//        separatorLeft.position = ccp(matchButton.position.x + (buttonSize.width / 2), yMidTopBar);
//        [uiBatch addChild:separatorLeft];
//        
//        CCSprite *separatorRight = [CCSprite spriteWithSpriteFrameName:@"control_separator.png"];
//        separatorRight.position = ccp(hamburgerButton.position.x - (buttonSize.width / 2), yMidTopBar);
//        [uiBatch addChild:separatorRight];
        
        
        
    
        // ticker control
//        CGPoint tickerControlOrigin = ccp(hitChartOrigin.x, hitChartOrigin.y + 40);
//        NSLog(@"tickerControlOrigin: %@", NSStringFromCGPoint(tickerControlOrigin));
//        //        TickerControl *tickerControl = [[TickerControl alloc] initWithNumberOfTicks:(tickDispatcher.sequenceLength / 4) padding:2 batchNode:uiBatch origin:tickerControlOrigin];
//        TickerControl *tickerControl = [[TickerControl alloc] initWithBatchNode:uiBatch steps:(tickDispatcher.sequenceLength / 4) unitSize:buttonSize];
//        tickerControl.delegate = tickDispatcher;
//        [self addChild:tickerControl];
        
//        // ticker control
//        CGPoint tickerControlOrigin = ccp(hitChartOrigin.x, hitChartOrigin.y + 40);
//        NSLog(@"tickerControlOrigin: %@", NSStringFromCGPoint(tickerControlOrigin));
////        TickerControl *tickerControl = [[TickerControl alloc] initWithNumberOfTicks:(tickDispatcher.sequenceLength / 4) padding:2 batchNode:uiBatch origin:tickerControlOrigin];
//        TickerControl *tickerControl = [[TickerControl alloc] initWithBatchNode:uiBatch steps:(tickDispatcher.sequenceLength / 4) unitSize:buttonSize];
//        tickerControl.delegate = tickDispatcher;
//        [self addChild:tickerControl];
        
//        // tick hit chart
//        CGPoint hitChartOrigin = ccp(matchButton.position.x + matchButton.contentSize.width, self.contentSize.height - topBarHeight);
//        TickHitChart *hitChart = [[TickHitChart alloc] initWithNumberOfTicks:tickDispatcher.sequenceLength padding:2 batchNode:uiBatch origin:hitChartOrigin];
//        [self addChild:hitChart];
//        _hitChart = hitChart;
        
        // drag items
        int i = 0;
        for (NSNumber *item in dragItems) {
            
            kDragItem itemType = [item intValue];
            DragButton *button = [[DragButton alloc] initWithItemType:itemType delegate:dragItemDelegate];
            
            CGFloat yOffset = (topBarHeight + (button.contentSize.height * (i + 1)));
            CGFloat yPos = self.contentSize.height - yOffset;
            button.position = ccp(self.contentSize.width - button.contentSize.width, yPos);
            
            [self addChild:button];
            i++;
        }
    }
    return self;
}

- (void)backButtonPressed:(id)sender
{
    [[CCDirector sharedDirector] popScene];
}

- (void)matchButtonPressed:(id)sender
{
    [self.tickDispatcher scheduleSequence];
}

- (void)runButtonPressed:(id)sender
{
    [self.hitChart resetCells];
    [self.tickDispatcher start];
}

- (void)hamburgerButtonPressed:(id)sender
{
    NSLog(@"halmborger");
}
                                             

@end
