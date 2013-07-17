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

- (id)initWithSynth:(id<SoundEventReceiver>)synth dragItemDelegate:(id<DragItemDelegate>)delegate cell:(GridCoord)cell
{
    CCSprite *sprite = [SpriteUtils spriteWithTextureKey:kImageWarpDefault];
    self = [super initWithSynth:synth dragItemDelegate:delegate dragSprite:sprite dragItemType:kDragItemWarp];
    if (self) {
        self.cell = cell;
        
        self.sprite = sprite;
        self.sprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:self.sprite];
        
        self.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
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
