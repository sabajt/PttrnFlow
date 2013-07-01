//
//  DragButton.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "TouchNode.h"

typedef enum
{
    kDragItemArrow = 0,
    kDragItemWarp,
    kDragItemSplitter,
} kDragItem;

@protocol DragButtonDelegate <NSObject>

- (void)dragItemDropped:(kDragItem)itemType touch:(UITouch *)touch;

@end


@interface DragButton : TouchNode

@property (weak, nonatomic) id<DragButtonDelegate> delegate;

+ (DragButton *)buttonWithItemType:(kDragItem)itemType defaultSprite:(CCSprite *)defaultSprite selectedSprite:(CCSprite *)selectedSprite dragItemSprite:(CCSprite *)itemSprite delegate:(id<DragButtonDelegate>)delegate;

@end
