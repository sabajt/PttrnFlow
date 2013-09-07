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
        [self setSpriteForFrameName:kImageWarpDefault];
    }
    return self;
}

#pragma mark - TickResponder

- (NSString *)tick:(NSInteger)bpm
{
    return @"";
}

- (void)afterTick:(NSInteger)bpm
{
    
}

- (GridCoord)responderCell
{
    return self.cell;
}

@end
