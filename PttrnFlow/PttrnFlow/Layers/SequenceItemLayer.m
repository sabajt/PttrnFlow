//
//  SequenceItemLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/29/13.
//
//

#import "SequenceItemLayer.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"

static CGFloat const kHandleHeight = 40;


@implementation SequenceItemLayer

// height is determined by number of items.
// items should be an array of NSNumbers from range in kDragItem.
// type kDragItem should define types of object the delegate will know how to create.
+ (id)layerWithBatchNode:(CCSpriteBatchNode *)batchNode color:(ccColor4B)color width:(GLfloat)w items:(NSArray *)items dragButtonDelegate:(id<DragItemDelegate>)delegate
{
    return [[SequenceItemLayer alloc] initWithBatchNode:batchNode color:color width:w height:(w * items.count) + kHandleHeight items:items dragButtonDelegate:delegate];
}

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode color:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h items:(NSArray *)items dragButtonDelegate:(id<DragItemDelegate>)delegate
{
    self = [super initWithColor:color width:w height:h];
    if (self) {
        int i = 0;
        for (NSNumber *item in items) {
            kDragItem itemType = [item intValue];
            DragButton *button = [self dragItemButtonWithBatchNode:batchNode itemType:itemType delegate:delegate];
            button.position = ccp(0, (button.contentSize.height * i) + kHandleHeight);
            [self addChild:button];
            i++;
        }
    }
    return self;
}

- (DragButton *)dragItemButtonWithBatchNode:(CCSpriteBatchNode *)batchNode itemType:(kDragItem)itemType delegate:(id<DragItemDelegate>)delegate
{
    NSString *defaultFrameName;
    NSString *selectedFrameName;
    NSString *dragFrameName;
    
    if (itemType == kDragItemArrow) {
        defaultFrameName = kImageArrowButton_off;
        selectedFrameName = kImageArrowButton_on;
        dragFrameName = kImageArrowUp;
    }
    else if (itemType == kDragItemWarp) {
        defaultFrameName = kImageWarpButton_off;
        selectedFrameName = kImageWarpButton_on;
        dragFrameName = kImageWarpDefault;
    }
    else if (itemType == kDragItemAudioStop) {
        defaultFrameName = kImageItemButtonAudioStopOff;
        selectedFrameName = kImageItemButtonAudioStopOn;
        dragFrameName = kImageAudioStop;
    }
    else if (itemType == kDragItemSpeedChange) {
        defaultFrameName = kImageItemButtonSpeedDoubleOff;
        selectedFrameName = kImageItemButtonSpeedDoubleOn;
        dragFrameName = kImageSpeedDouble;
    }
    else {
        NSLog(@"warning: unsupported kDragItem type, enum %i", itemType);
    }
    
//    return [[DragButton alloc] initWithItemType:<#(kDragItem)#> defaultFrameName:<#(NSString *)#> selectedFrameName:<#(NSString *)#> dragFrameName:<#(NSString *)#> delegate:<#(id<DragItemDelegate>)#>]
//    return [DragButton buttonWithItemType:itemType defaultSprite:defaultSprite selectedSprite:selectedSprite dragItemSprite:dragSprite delegate:delegate];
}

@end
