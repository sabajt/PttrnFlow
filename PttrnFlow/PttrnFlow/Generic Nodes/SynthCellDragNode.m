//
//  SynthCellDragNode.m
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "SynthCellDragNode.h"
#import "CCNode+DragItem.h"

@interface SynthCellDragNode ()

@property (assign) BOOL hasStartedDrag;
@property (assign) kDragItem dragItemType;

@property (strong, nonatomic) UITouch *initialTouch;
@property (strong, nonatomic) UIEvent *initialEvent;

@property (weak, nonatomic) CCSprite *dragSprite;
@property (weak, nonatomic) id<DragItemDelegate> dragItemDelegate;

@end


@implementation SynthCellDragNode

#pragma mark - SynthCellNode

- (id)initWithSynth:(id<SoundEventReceiver>)synth dragItemDelegate:(id<DragItemDelegate>)delegate dragSprite:(CCSprite *)dragSprite dragItemType:(kDragItem)dragItemType
{
    self = [super initWithSynth:synth];
    if (self) {
        self.longPressDelay = 0.5;
        self.hasStartedDrag = NO;
        self.dragItemDelegate = delegate;
        self.dragItemType = dragItemType;
        self.dragSprite = dragSprite;
        _cancelTouch = NO;
        
        dragSprite.visible = NO;
        [self addChild:dragSprite];

    }
    return self;
}

- (void)styleForDragging:(BOOL)shouldStyleForDragging
{
    self.sprite.visible = YES;
    if (shouldStyleForDragging) {
        self.sprite.opacity = 100.0f;
    }
    else {
        self.sprite.opacity = 255.0f;
    }
}

#pragma mark - TouchNode

- (void)longPress:(ccTime)deltaTime
{
    self.hasStartedDrag = YES;
    [self dragTouchBegan:self.initialTouch dragSprite:self.dragSprite];
    [self.dragItemDelegate dragItemBegan:self.dragItemType touch:self.initialTouch sender:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLockPan object:nil];
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        self.cancelTouch = NO;
        self.initialTouch = touch;
        self.initialEvent = event;
        return YES;
    }
    return NO;
};

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchMoved:touch withEvent:event];
    
    if (self.hasStartedDrag) {
        [self dragTouchMoved:touch dragSprite:self.dragSprite dragItemDelegate:self.dragItemDelegate itemType:self.dragItemType sender:self];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUnlockPan object:nil];
    
    if (self.hasStartedDrag) {
        [self dragTouchEnded:touch dragSprite:self.dragSprite dragItemDelegate:self.dragItemDelegate itemType:self.dragItemType sender:self];
        
        // remove
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRemoveTickReponder object:self];
        [self removeFromParentAndCleanup:YES];
    }    
}

@end
