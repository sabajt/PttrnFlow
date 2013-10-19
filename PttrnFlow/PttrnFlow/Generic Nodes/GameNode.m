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
        self.touchNodeDelegate = self;
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
    self = [self init];
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
    
    // modified version of CCLayerPanZoom sends this notification when we start panning,
    // drag distance buffer specified by a layer's maxTouchDistanceToClick property
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartPan) name:kNotificationStartPan object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // make sure sprite is removed from batch node
    [self.sprite removeFromParentAndCleanup:YES];
    [super onExit];
}

#pragma mark - TouchNodeDelegate

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    
    NSLog(@"\n\n\n**** **** ****\n---GameNode: %@\n---touch pos: %@\n---spr bounding box: %@\n---contains touch: %i", self, NSStringFromCGPoint(touchPosition), NSStringFromCGRect(self.sprite.boundingBox), CGRectContainsPoint(self.sprite.boundingBox, touchPosition));
    
    return (CGRectContainsPoint(self.sprite.boundingBox, touchPosition));
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
}

- (void)setSpriteForFrameName:(NSString *)name cell:(GridCoord)cell
{
    [self setSpriteForFrameName:name];
    self.sprite.position = [GridUtils relativeMidpointForCell:cell unitSize:kSizeGridUnit];
}

- (void)setSpriteForFrameName:(NSString *)name position:(CGPoint)position
{
    [self setSpriteForFrameName:name];
    self.sprite.position = position;
}


- (CGFloat)spriteWidth
{
    return self.sprite.boundingBox.size.width;
}

- (CGFloat)spriteHeight
{
    return self.sprite.boundingBox.size.height;
}

//////////////////////////////////////////////////////////////////////////////
// TODO: generalize align methods to work without cells or move somewhere else
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

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

#pragma mark - Handle panning

// pan notification
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

