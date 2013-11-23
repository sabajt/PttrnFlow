//
//  AudioStop.m
//  PttrnFlow
//
//  Created by John Saba on 8/26/13.
//
//

#import "AudioStop.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"
#import "TickDispatcher.h"

@implementation AudioStop

// use this method to initialize dynamically
//- (id)initWithCell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate;
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate
{
    CCSprite *dragSprite = [CCSprite spriteWithSpriteFrameName:kImageAudioStop];
    self = [super initWithBatchNode:batchNode cell:cell dragItemDelegate:delegate dragSprite:dragSprite dragItemType:kDragItemAudioStop];
    if (self) {
        [self setSpriteForFrameName:kImageAudioStop cell:cell];
    }
    return self;
}

#pragma mark - SynthCellNode

- (void)cancelTouchForPan
{
    [super cancelTouchForPan];
    [self audioRelease:kBPM];
}

#pragma mark - AudioResponder

- (NSArray *)audioHit:(NSInteger)bpm
{
    return @[@"audio_stop"];
}

- (void)audioRelease:(NSInteger)bpm
{
    
}

- (GridCoord)responderCell
{
    return self.cell;
}


@end
