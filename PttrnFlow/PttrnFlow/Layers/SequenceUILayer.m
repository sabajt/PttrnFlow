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

static CGFloat const kHandleHeight = 40;

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
        
        // sizes
        CGFloat topBarHeight = 80.0;
        CGFloat yMidTopBar = self.contentSize.height - (topBarHeight/2);
        CGSize buttonSize = CGSizeMake(topBarHeight, topBarHeight);
        
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        [self addChild:uiBatch];
        self.uiBatchNode = uiBatch;
        
        // tick dispatcher
        _tickDispatcher = tickDispatcher;
        
        // back button
        CCSprite *backDefault = [CCSprite spriteWithSpriteFrameName:@"back_arrow_off.png"];
        CCSprite *backSelected = [CCSprite spriteWithSpriteFrameName:@"back_arrow_on.png"];
        CCMenuItemSprite *backButton = [[CCMenuItemSprite alloc] initWithNormalSprite:backDefault selectedSprite:backSelected disabledSprite:nil target:self selector:@selector(backButtonPressed:)];
        backButton.position = ccp(buttonSize.width/2, yMidTopBar);
        
        // match sequence button
        CCSprite *matchDefault = [CCSprite spriteWithSpriteFrameName:@"speaker_off.png"];
        CCSprite *matchSelected = [CCSprite spriteWithSpriteFrameName:@"speaker_on.png"];
        CCMenuItemSprite *matchButton = [[CCMenuItemSprite alloc] initWithNormalSprite:matchDefault selectedSprite:matchSelected disabledSprite:nil target:self selector:@selector(matchButtonPressed:)];
        matchButton.position = ccp(backButton.position.x + backButton.contentSize.width, yMidTopBar);
        
        // run button
        CCSprite *runDefault = [CCSprite spriteWithSpriteFrameName:@"play_off.png"];
        CCSprite *runSelected = [CCSprite spriteWithSpriteFrameName:@"play_on.png"];
        CCMenuItemSprite *runButton = [[CCMenuItemSprite alloc] initWithNormalSprite:runDefault selectedSprite:runSelected disabledSprite:nil target:self selector:@selector(runButtonPressed:)];
        runButton.position = ccp(self.contentSize.width - buttonSize.width/2, yMidTopBar);
        
        // buttons must be added to a CCMenu to work
        CCMenu *menu = [CCMenu menuWithItems:backButton, matchButton, runButton, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
        
        // tick hit chart
        CGPoint hitChartOrigin = ccp(matchButton.position.x + matchButton.contentSize.width, self.contentSize.height - topBarHeight);
        TickHitChart *hitChart = [[TickHitChart alloc] initWithNumberOfTicks:tickDispatcher.sequenceLength padding:2 batchNode:uiBatch origin:hitChartOrigin];
        [self addChild:hitChart];
        _hitChart = hitChart;
        
//        // ticker control
//        TickerControl *tickerControl = [[TickerControl alloc] initWithNumberOfTicks:(tickDispatcher.sequenceLength / 4) distanceInterval:kTickScrubberDistanceInterval];
//        tickerControl.delegate = tickDispatcher;
//        tickerControl.position = ccp(hitChart.position.x, hitChart.position.y + hitChart.contentSize.height + 2);
//        [self addChild:tickerControl];
        
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

@end
