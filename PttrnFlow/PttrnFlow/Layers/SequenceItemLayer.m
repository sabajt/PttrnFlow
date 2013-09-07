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
    CCSprite *defaultSprite;
    CCSprite *selectedSprite;
    CCSprite *dragSprite;
    
    if (itemType == kDragItemArrow) {
        selectedSprite = [CCSprite spriteWithSpriteFrameName:kImageArrowButton_on];
        dragSprite = [CCSprite spriteWithSpriteFrameName:kImageArrowUp];
        defaultSprite = [CCSprite spriteWithSpriteFrameName:kImageArrowButton_off];
    }
    else if (itemType == kDragItemWarp) {
        defaultSprite = [CCSprite spriteWithSpriteFrameName:kImageWarpButton_off];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:kImageWarpButton_on];
        dragSprite = [CCSprite spriteWithSpriteFrameName:kImageWarpDefault];
    }
    else if (itemType == kDragItemAudioStop) {
        defaultSprite = [CCSprite spriteWithSpriteFrameName:kImageItemButtonAudioStopOff];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:kImageItemButtonAudioStopOn];
        dragSprite = [CCSprite spriteWithSpriteFrameName:kImageAudioStop];
    }
    else if (itemType == kDragItemSpeedChange) {
        defaultSprite = [CCSprite spriteWithSpriteFrameName:kImageItemButtonSpeedDoubleOff];
        selectedSprite = [CCSprite spriteWithSpriteFrameName:kImageItemButtonSpeedDoubleOn];
        dragSprite = [CCSprite spriteWithSpriteFrameName:kImageSpeedDouble];
    }
    else {
        NSLog(@"warning: unsupported kDragItem type, enum %i", itemType);
    }
    
    return [DragButton buttonWithBatchNode:batchNode itemType:itemType defaultSprite:defaultSprite selectedSprite:selectedSprite dragItemSprite:dragSprite delegate:delegate];
}

@end
