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
+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w items:(NSArray *)items dragButtonDelegate:(id<DragItemDelegate>)delegate
{
    return [[SequenceItemLayer alloc] initWithColor:color width:w height:(w * items.count) + kHandleHeight items:items dragButtonDelegate:delegate];
}

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h items:(NSArray *)items dragButtonDelegate:(id<DragItemDelegate>)delegate
{
    self = [super initWithColor:color width:w height:h];
    if (self) {
        int i = 0;
        for (NSNumber *item in items) {
            kDragItem itemType = [item intValue];
            DragButton *button = [self dragItemButton:itemType delegate:delegate];
            button.position = ccp(0, (button.contentSize.height * i) + kHandleHeight);
            [self addChild:button];
            i++;
        }
    }
    return self;
}

- (DragButton *)dragItemButton:(kDragItem)itemType delegate:(id<DragItemDelegate>)delegate
{
    CCSprite *defaultSprite;
    CCSprite *selectedSprite;
    CCSprite *dragSprite;
    
    if (itemType == kDragItemArrow) {
        defaultSprite = [SpriteUtils spriteWithTextureKey:kImageArrowButton_off];
        selectedSprite = [SpriteUtils spriteWithTextureKey:kImageArrowButton_on];
        dragSprite = [SpriteUtils spriteWithTextureKey:kImageArrowUp];
    }
    else if (itemType == kDragItemWarp) {
        defaultSprite = [SpriteUtils spriteWithTextureKey:kImageWarpButton_off];
        selectedSprite = [SpriteUtils spriteWithTextureKey:kImageWarpButton_on];
        dragSprite = [SpriteUtils spriteWithTextureKey:kImageWarpDefault];
    }
    else {
        NSLog(@"warning: unsupported kDragItem type, enum %i", itemType);
    }
    return [DragButton buttonWithItemType:itemType defaultSprite:defaultSprite selectedSprite:selectedSprite dragItemSprite:dragSprite delegate:delegate];
}

@end
