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
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode Cell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate speed:(NSString *)speed
{
    CCSprite *dragSprite = [CCSprite spriteWithSpriteFrameName:kImageSpeedDouble];
    self = [super initWithBatchNode:batchNode cell:cell dragItemDelegate:delegate dragSprite:dragSprite dragItemType:kDragItemSpeedChange];
    if (self) {
        self.speed = speed;
        [self setSpriteForFrameName:kImageSpeedDouble cell:cell];
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
