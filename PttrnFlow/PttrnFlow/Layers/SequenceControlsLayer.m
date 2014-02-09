//
//  SequenceUILayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "SequenceControlsLayer.h"
#import "ColorUtils.h"
#import "TileSprite.h"
#import "ClippingSprite.h"
#import "PuzzleDataManager.h"
#import "GameConstants.h"
#import "SequenceDispatcher.h"

CGFloat const kUIButtonUnitSize = 50;
CGFloat const kUITimelineStepWidth = 40;

static NSInteger const kRowLength = 8;

@interface SequenceControlsLayer ()

@property (weak, nonatomic) CCSpriteBatchNode *uiBatchNode;
@property (weak, nonatomic) id<SequenceControlDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *solutionButtons;

// size and positions
@property (assign) NSInteger steps;

// buttons
@property (weak, nonatomic) ToggleButton *speakerButton;
@property (weak, nonatomic) ToggleButton *playButton;
@property (weak, nonatomic) BasicButton *exitButton;

@end

@implementation SequenceControlsLayer

- (id)initWithPuzzle:(NSUInteger)puzzle delegate:(id<SequenceControlDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        NSInteger steps = 4;
        self.steps = steps;
        
        // batch node
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        self.uiBatchNode = uiBatch;
        
        // right controls panel
        CCSprite *rightControlsPanel = [CCSprite spriteWithSpriteFrameName:@"controls_panel_right_bottom.png"];
        rightControlsPanel.anchorPoint = ccp(0, 0);
        
        if (steps >= kRowLength) {
            rightControlsPanel.position = ccp(rightControlsPanel.contentSize.width - self.contentSize.width, 0);
        }
        else {
            CGFloat xOffset = (rightControlsPanel.contentSize.width - self.contentSize.width) + (kUITimelineStepWidth * (kRowLength - steps));
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
        speakerButton.position = ccp(kUITimelineStepWidth / 2, 75); // FIX ME LATER
        [self.uiBatchNode addChild:speakerButton];
        
        // play (user sequence) button
        ToggleButton *playButton = [[ToggleButton alloc] initWithPlaceholderFrameName:@"clear_rect_uilayer.png" offFrameName:@"play_off.png" onFrameName:@"play_on.png" delegate:self];
        self.playButton = playButton;
        playButton.position = ccp(speakerButton.position.x + kUITimelineStepWidth, speakerButton.position.y);
        [self.uiBatchNode addChild:playButton];
        
        // exit button
        BasicButton *exitButton = [[BasicButton alloc] initWithPlaceholderFrameName:@"clear_rect_uilayer.png" offFrameName:@"exit_off.png" onFrameName:@"exit_on.png" delegate:self];
        self.exitButton = exitButton;
        exitButton.position = ccp(kUITimelineStepWidth / 2, self.contentSize.height - 25);
        [self.uiBatchNode addChild:exitButton];
        
        // solution buttons
        self.solutionButtons = [NSMutableArray array];
        for (NSInteger i = 0; i < steps; i++) {
            SolutionButton *solutionButton = [[SolutionButton alloc] initWithIndex:i delegate:self];
            [self.solutionButtons addObject:solutionButton];
            solutionButton.position = ccp((i * kUITimelineStepWidth) + (solutionButton.contentSize.width / 2), solutionButton.contentSize.height / 2);
            [self addChild:solutionButton];
        }
    }
    return self;
}

#pragma mark - Scene management

- (void)onEnter
{
    [super onEnter];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handleStepSolutionSequence:) name:kNotificationStepSolutionSequence object:nil];
    [notificationCenter addObserver:self selector:@selector(handleEndUserSequence:) name:kNotificationEndUserSequence object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

#pragma mark - Notifications

- (void)handleStepSolutionSequence:(NSNotification *)notification
{
    NSNumber *number = notification.userInfo[kKeyIndex];
    for (SolutionButton *button in self.solutionButtons) {
        if (button.index == [number integerValue]) {
            [button press];
            return;
        }
    }
}

- (void)handleEndUserSequence:(NSNotification *)notification
{
    [self.playButton toggle];
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

#pragma mark - BasicButtonDelegate

- (void)basicButtonPressed:(BasicButton *)sender
{
    if ([sender isEqual:self.exitButton]) {
        [[CCDirector sharedDirector] popScene];
    }
}

#pragma mark - SolutionButtonDelegate

- (void)solutionButtonPressed:(SolutionButton *)button
{
    [self.delegate playSolutionIndex:button.index];
}

@end
