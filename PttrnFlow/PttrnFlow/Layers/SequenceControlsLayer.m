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
@property (strong, nonatomic) NSMutableArray *solutionFlags;

// size and positions
@property (assign) NSInteger steps;

// buttons
@property (weak, nonatomic) ToggleButton *speakerButton;
@property (weak, nonatomic) ToggleButton *playButton;
@property (weak, nonatomic) BasicButton *exitButton;

@end

@implementation SequenceControlsLayer

- (id)initWithPuzzle:(Puzzle *)puzzle delegate:(id<SequenceControlDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        NSInteger steps = 4;
        self.steps = steps;
        
        // batch node
        CCSpriteBatchNode *uiBatch = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyUILayer stringByAppendingString:@".png"]];
        self.uiBatchNode = uiBatch;
        [self addChild:uiBatch];
        
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
        
        
        // speaker (solution sequence) button
        ToggleButton *speakerButton = [[ToggleButton alloc] initWithFrameName:@"speaker.png" defaultColor:[ColorUtils dimPurple] activeColor:[ColorUtils activeYellow] delegate:self];
        self.speakerButton = speakerButton;
        speakerButton.position = ccp(kUITimelineStepWidth / 2, 75); // FIX ME LATER
        [self.uiBatchNode addChild:speakerButton];
        
        // play (user sequence) button
        ToggleButton *playButton = [[ToggleButton alloc] initWithFrameName:@"play.png" defaultColor:[ColorUtils dimPurple] activeColor:[ColorUtils activeYellow] delegate:self];
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
        self.solutionFlags = [NSMutableArray array];
        for (NSInteger i = 0; i < steps; i++) {
            SolutionButton *solutionButton = [[SolutionButton alloc] initWithPlaceholderFrameName:@"clear_rect_uilayer.png" size:CGSizeMake(40.0f, 40.0f) index:i delegate:self];
            [self.solutionButtons addObject:solutionButton];
            solutionButton.position = ccp((i * kUITimelineStepWidth) + (solutionButton.contentSize.width / 2), solutionButton.contentSize.height / 2);
            [self addChild:solutionButton];
        }
    }
    return self;
}

// TODO: if this becomes a custom animation (crossfade?) will probably need to use with a completion callback
- (void)resetSolutionButtons
{
    for (SolutionButton *button in self.solutionButtons) {
        if (button.isDisplaced) {
            [button reset];
        }
    }
    
    for (CCSprite *flag in self.solutionFlags) {
        [flag removeFromParentAndCleanup:YES];
    }
    [self.solutionFlags removeAllObjects];
}

#pragma mark - Scene management

- (void)onEnter
{
    [super onEnter];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(handleStepUserSequence:) name:kNotificationStepUserSequence object:nil];
    [notificationCenter addObserver:self selector:@selector(handleStepSolutionSequence:) name:kNotificationStepSolutionSequence object:nil];
    [notificationCenter addObserver:self selector:@selector(handleEndUserSequence:) name:kNotificationEndUserSequence object:nil];
    [notificationCenter addObserver:self selector:@selector(handleEndSolutionSequence:) name:kNotificationEndSolutionSequence object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

#pragma mark - Notifications

- (void)handleStepUserSequence:(NSNotification *)notification
{
    NSInteger index = [notification.userInfo[kKeyIndex] integerValue];
    BOOL correct = [notification.userInfo[kKeyCorrectHit] boolValue];
    
    SolutionButton *button = self.solutionButtons[index];
    [button animateCorrectHit:correct];
    
    CGFloat  offset = 6.0f;
    NSString *flagName = @"x.png";
    if (correct) {
        offset *= -1.0f;
        flagName = @"check.png";
    }
    
    // create and animate solution flag (check or x)
    CCSprite *flag = [CCSprite spriteWithSpriteFrameName:flagName];
    [self.solutionFlags addObject:flag];
    [self.uiBatchNode addChild:flag];
    flag.color = [ColorUtils defaultPurple];
    flag.position = ccp(button.position.x, button.contentSize.height / 2);
    flag.opacity = 0.0f;
    CCMoveTo *flagMoveTo = [CCMoveTo actionWithDuration:1.0f position:ccp(flag.position.x, (button.contentSize.height / 2) + offset)];
    CCEaseElasticOut *flagEase = [CCEaseElasticOut actionWithAction:flagMoveTo];
    [flag runAction:flagEase];
    CCFadeIn *flagFadeIn = [CCFadeIn actionWithDuration:0.5f];
    [flag runAction:flagFadeIn];
}

// SequenceDispatcher needs us to press the solution button
- (void)handleStepSolutionSequence:(NSNotification *)notification
{
    SolutionButton *button = self.solutionButtons[[notification.userInfo[kKeyIndex] integerValue]];
    [button press];
}

// SequenceDispatcher needs us to toggle off the the play button
- (void)handleEndUserSequence:(NSNotification *)notification
{
    [self.playButton toggle];
}

// SequenceDispatcher needs us to toggle off the the speaker button
- (void)handleEndSolutionSequence:(NSNotification *)notification
{
    [self.speakerButton toggle];
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
            [self resetSolutionButtons];
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
