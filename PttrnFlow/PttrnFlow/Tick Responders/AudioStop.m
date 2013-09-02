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
- (id)initWithCell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate;
{
    CCSprite *dragSprite = [SpriteUtils spriteWithTextureKey:kImageAudioStop];;
    self = [super initWithDragItemDelegate:delegate dragSprite:dragSprite dragItemType:kDragItemAudioStop];
    if (self) {
        self.cell = cell;
        self.sprite = [self createAndCenterSpriteNamed:kImageAudioStop];
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
    return @[@"audio_stop"];
}

- (void)afterTick:(NSInteger)bpm
{
    
}

- (GridCoord)responderCell
{
    return self.cell;
}


@end
