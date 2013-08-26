//
//  SpeedChange.m
//  PttrnFlow
//
//  Created by John Saba on 8/26/13.
//
//

#import "SpeedChange.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"
#import "TickDispatcher.h"

@implementation SpeedChange

// use this method to initialize dynamically
- (id)initWithCell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate speed:(NSString *)speed;
{
    CCSprite *dragSprite = [SpriteUtils spriteWithTextureKey:kImageWarpDefault];;
    self = [super initWithDragItemDelegate:delegate dragSprite:dragSprite dragItemType:kDragItemSpeedChange];
    if (self) {
        self.cell = cell;
        self.speed = speed;
        self.sprite = [self createAndCenterSpriteNamed:kImageWarpDefault];
        self.position = [GridUtils relativePositionForGridCoord:cell unitSize:kSizeGridUnit];
        [self addChild:self.sprite];
    }
    return self;
}

#pragma mark - SynthCellNode

- (void)cancelTouchForPan
{
    [super cancelTouchForPan];
    [self afterTick:kBPM];
}

#pragma mark - TickResponder

- (NSArray *)tick:(NSInteger)bpm
{
    return @[self.speed];
}

- (void)afterTick:(NSInteger)bpm
{
    
}

- (GridCoord)responderCell
{
    return self.cell;
}

@end
