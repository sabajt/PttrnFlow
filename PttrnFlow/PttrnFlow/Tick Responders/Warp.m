//
//  Warp.m
//  PttrnFlow
//
//  Created by John Saba on 7/16/13.
//
//

#import "Warp.h"
#import "SpriteUtils.h"
#import "TextureUtils.h"

@implementation Warp

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode dragItemDelegate:(id<DragItemDelegate>)delegate cell:(GridCoord)cell
{
    CCSprite *dragSprite = [SpriteUtils spriteWithTextureKey:kImageWarpDefault];
    self = [super initWithBatchNode:batchNode cell:cell dragItemDelegate:delegate dragSprite:dragSprite dragItemType:kDragItemWarp];
    if (self) {
        [self setSpriteForFrameName:kImageWarpDefault cell:cell];
    }
    return self;
}

#pragma mark - AudioResponder

- (NSString *)audioHit:(NSInteger)bpm
{
    return @"";
}

- (GridCoord)responderCell
{
    return self.cell;
}

@end
