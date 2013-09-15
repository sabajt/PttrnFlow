//
//  GameNode.m
//  PttrnFlow
//
//  Created by John Saba on 9/14/13.
//
//

#import "GameNode.h"

@implementation GameNode

- (id)init
{
    self = [super init];
    if (self) {
        _swallowsTouches = NO;
        _longPressDelay = 0;
        _isReceivingTouch = NO;
    }
    return self;
}

// holds batch node as weak ref, so make sure someone else owns batch node first
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode
{
    self = [self init];
    if (self) {
        _batchNode = batchNode;
    }
    return self;
}

- (id)initWithCell:(GridCoord)cell
{
    self = [super init];
    if (self) {
        _cell = cell;
        _cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

// init with batch node and cell
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell
{
    self = [self initWithBatchNode:batchNode];
    if (self) {
        _cell = cell;
        _cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

#pragma mark CCNode SceneManagement

- (void)onEnter
{
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:self.swallowsTouches];
    
    // modified version of CCLayerPanZoom sends this notification when we start panning,
    // drag distance buffer specified by a layer's maxTouchDistanceToClick property
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartPan) name:kNotificationStartPan object:nil];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.sprite removeFromParentAndCleanup:YES];
    
    [super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouch:touch]) {
        self.isReceivingTouch = YES;
        if (self.longPressDelay > 0) {
            [self scheduleOnce:@selector(longPress:) delay:self.longPressDelay];
        }
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![self containsTouch:touch] && (self.longPressDelay > 0)) {
        [self unschedule:@selector(longPress:)];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.longPressDelay > 0) {
        [self unschedule:@selector(longPress:)];
    }
    self.isReceivingTouch = NO;
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.longPressDelay > 0) {
        [self unschedule:@selector(longPress:)];
    }
    self.isReceivingTouch = NO;
}

#pragma mark - Extended touch handling

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    return (CGRectContainsPoint(self.sprite.boundingBox, touchPosition));
}

- (void)longPress:(ccTime)deltaTime
{
    NSLog(@"long press needs implementation");
}

#pragma mark - Sprite helpers

- (void)setSpriteForFrameName:(NSString *)name
{
    [self.sprite removeFromParentAndCleanup:YES];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:name];
    self.sprite = sprite;
    
    if (self.batchNode == nil) {
        [self addChild:sprite];
    } 
    else {
        [self.batchNode addChild:sprite];
    }
    
    // positioning should be generalized or handled somewhere else
    sprite.position = [GridUtils relativeMidpointForCell:self.cell unitSize:kSizeGridUnit];
}

- (CGFloat)spriteWidth
{
    return self.sprite.boundingBox.size.width;
}

- (CGFloat)spriteHeight
{
    return self.sprite.boundingBox.size.height;
}

- (void)alignSprite:(kDirection)direction
{
    switch (direction) {
        case kDirectionUp:
            [self topAlignSprite];
            break;
        case kDirectionRight:
            [self rightAlignSprite];
            break;
        case kDirectionDown:
            [self bottomAlignSprite];
            break;
        case kDirectionLeft:
            [self leftAlignSprite];
            break;
        default:
            NSLog(@"warning: invalid direction, can't align sprite");
            break;
    }
}

- (void)leftAlignSprite
{
    CGPoint relativeOrigin = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    self.sprite.position = CGPointMake(relativeOrigin.x + ([self spriteWidth] / 2), relativeOrigin.y + (self.cellSize.height / 2));
}

- (void)rightAlignSprite
{
    CGPoint relativeOrigin = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    self.sprite.position = CGPointMake((relativeOrigin.x + self.cellSize.width) - ([self spriteWidth] / 2), relativeOrigin.y + (self.cellSize.height / 2));
}

- (void)topAlignSprite
{
    CGPoint relativeOrigin = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    self.sprite.position = CGPointMake(relativeOrigin.x + (self.cellSize.width / 2), relativeOrigin.y + (self.cellSize.height - ([self spriteHeight] / 2)));
}

- (void)bottomAlignSprite
{
    CGPoint relativeOrigin = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    self.sprite.position = CGPointMake(relativeOrigin.x + (self.cellSize.width / 2), relativeOrigin.y + ([self spriteHeight] / 2));
}

#pragma mark - Handle panning

- (void)handleStartPan
{
    [self cancelTouchForPan];
}

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan
{
    if (self.longPressDelay > 0) {
        [self unschedule:@selector(longPress:)];
    }
}


@end

