//
//  CellNode.m
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "CellNode.h"
#import "GameConstants.h"
#import "SpriteUtils.h"
#import "SGTiledUtils.h"
#import "CCSprite+Utils.h"


@implementation CellNode

// TODO: replace with method below
- (id)init
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

// holds batch node as weak ref, so make sure someone else owns batch node first
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell
{
    self = [super init];
    if (self) {
        self.touchNodeDelegate = self;
        _batchNode = batchNode;
        _cell = cell;
        _cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

- (CGPoint)relativeMidpoint
{
    CGPoint relativeOrigin = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    return ccp(relativeOrigin.x + self.cellSize.width/2, relativeOrigin.y + self.cellSize.height/2);
}

#pragma mark - Sprite helpers

// replace current sprite we point to in batch node with new sprite created from frame catch
- (void)setSpriteForFrameName:(NSString *)name
{
    [self.sprite removeFromParentAndCleanup:YES];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:name];
    sprite.position = [self relativeMidpoint];
    
    if (self.batchNode == nil) {
        NSLog(@"warning: batch node not set on cell node");
    }
    [self.batchNode addChild:sprite];
    self.sprite = sprite;
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

// TODO: need to change these to not use content size
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
    [self.sprite removeFromParentAndCleanup:YES];
    [super onExit];
}

#pragma mark - TouchNodeDelegate

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    return (CGRectContainsPoint(self.sprite.boundingBox, touchPosition));
}

@end
