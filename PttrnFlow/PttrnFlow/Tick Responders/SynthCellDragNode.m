//
//  SynthCellDragNode.m
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "SynthCellDragNode.h"

@interface SynthCellDragNode ()

@property (assign) BOOL hasStartedDrag;
@property (weak, nonatomic) id<DragButtonTouchProxy> dragProxy;
@property (strong, nonatomic) UITouch *initialTouch;
@property (strong, nonatomic) UIEvent *initialEvent;

@end


@implementation SynthCellDragNode

#pragma mark - SynthCellNode

- (id)initWithSynth:(id<SoundEventReceiver>)synth dragProxy:(id<DragButtonTouchProxy>)dragProxy;
{
    self = [super initWithSynth:synth];
    if (self) {
        self.longPressDelay = 0.8;
        self.hasStartedDrag = NO;
        self.dragProxy = dragProxy;
    }
    return self;
}

#pragma mark - TouchNode

- (void)longPress:(ccTime)deltaTime
{
    self.hasStartedDrag = YES;
    [self.dragProxy forwardDragTouchBegan:self.initialTouch withEvent:self.initialEvent];
    self.visible = NO;
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        self.initialTouch = touch;
        self.initialEvent = event;
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.hasStartedDrag) {
        [self.dragProxy forwardDragTouchMoved:touch withEvent:event];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    
    if (self.hasStartedDrag) {
        self.hasStartedDrag = NO;
        [self.dragProxy forwardDragTouchEnded:touch withEvent:event];
        [self removeFromParentAndCleanup:YES];
    }
}

@end
