//
//  Arrow.m
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//

#import "Arrow.h"
#import "CCTMXTiledMap+Utils.h"
#import "SGTiledUtils.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"
#import "TickDispatcher.h"
#import "DragButton.h"
#import "TickEvent.h"

@implementation Arrow

// use this method to initialize via tiled map
- (id)initWithArrow:(NSMutableDictionary *)arrow batchNode:(CCSpriteBatchNode *)batchNode tiledMap:(CCTMXTiledMap *)tiledMap dragItemDelegate:(id<DragItemDelegate>)delegate
{
    GridCoord cell = [tiledMap gridCoordForObject:arrow];
    kDirection facing = [SGTiledUtils directionNamed:[CCTMXTiledMap objectPropertyNamed:kTLDPropertyDirection object:arrow]];
    return [self initWithCell:cell batchNode:batchNode facing:facing dragItemDelegate:delegate];
}

// use this method to initialize dynamically
- (id)initWithCell:(GridCoord)cell batchNode:(CCSpriteBatchNode *)batchNode facing:(kDirection)facing dragItemDelegate:(id<DragItemDelegate>)delegate;
{
    CCSprite *dragSprite = [CCSprite spriteWithSpriteFrameName:kImageArrowUp];
    self = [super initWithBatchNode:batchNode cell:cell dragItemDelegate:delegate dragSprite:dragSprite dragItemType:kDragItemArrow];
    if (self) {
        self.cell = cell;
        self.facing = facing;
        [self setSpriteForFrameName:[self frameNameForFacing:facing] cell:cell];
        
    }
    return self;
}

- (NSString *)frameNameForFacing:(kDirection)facing
{
    switch (facing) {
        case kDirectionDown:
            return kImageArrowDown;
        case kDirectionUp:
            return kImageArrowUp;
        case kDirectionLeft:
            return kImageArrowLeft;
        case kDirectionRight:
            return kImageArrowRight;
        default:
            NSLog(@"warning: invalid direction for arrow image");
            return @"";
            break;
    }
}

- (void)rotateClockwise
{
    if (self.facing == kDirectionUp) {
        self.facing = kDirectionRight;
    }
    else if (self.facing == kDirectionRight) {
        self.facing = kDirectionDown;
    }
    else if (self.facing == kDirectionDown) {
        self.facing = kDirectionLeft;
    }
    else if (self.facing == kDirectionLeft) {
        self.facing = kDirectionUp;
    }

    [self setSpriteForFrameName:[self frameNameForFacing:self.facing] cell:self.cell];
}

#pragma mark - SynthCellNode

- (void)cancelTouchForPan
{
    [super cancelTouchForPan];
    [self audioRelease:kBPM];
}

#pragma mark - CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super ccTouchBegan:touch withEvent:event]) {
        [self rotateClockwise];
        return YES;
    }
    return NO;
}

#pragma mark - AudioResponder

- (NSArray *)audioHit:(NSInteger)bpm
{
    // TODO: FIX MEEEE
    return @[[GridUtils directionStringForDirection:self.facing]];
}

- (NSArray *)audioRelease:(NSInteger)bpm
{
    return nil;
}

- (GridCoord)responderCell
{
    return self.cell;
}

@end
