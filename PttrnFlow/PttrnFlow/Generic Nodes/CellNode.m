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
#import "CCNode+Touch.h"
#import "CCSprite+Utils.h"


@implementation CellNode

- (id)init
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

// holds batch node as weak ref, so make sure someone else owns batch node first
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        _batchNode = batchNode;
    }
    return self;
}

// replace current sprite we point to in batch node with new sprite created from frame catch
- (void)switchSpriteForFrameName:(NSString *)name
{
    [self.sprite removeFromParentAndCleanup:YES];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:name];
    CGPoint relativeOrigin = [GridUtils relativePositionForGridCoord:self.cell unitSize:kSizeGridUnit];
    sprite.position = ccp(relativeOrigin.x + self.contentSize.width/2, relativeOrigin.y + self.contentSize.height/2);
    [self.batchNode addChild:sprite];
    self.sprite = sprite;
}


//TODO: old should delete
- (CCSprite *)createAndCenterSpriteNamed:(NSString *)name
{
    CCSprite *sprite = [SpriteUtils spriteWithTextureKey:name];
    sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    return sprite;
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
    self.sprite.position = CGPointMake(self.sprite.contentSize.width/2, self.contentSize.height/2);
}

- (void)rightAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width - self.sprite.contentSize.width/2, self.contentSize.height/2);
}

- (void)topAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.contentSize.height - self.sprite.contentSize.height/2);
}

- (void)bottomAlignSprite
{
    self.sprite.position = CGPointMake(self.contentSize.width/2, self.sprite.contentSize.height/2);
}

- (void)onEnter
{
    [super onEnter];
    // modified version of CCLayerPanZoom sends this notification when we start panning -- drag distance buffer specified by a layer's maxTouchDistanceToClick property
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartPan) name:kNotificationStartPan object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

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
