//
//  DragButton.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "TouchNode.h"

@class DragButton;

// types of game objects that the delegate should know how to create
typedef enum
{
    kDragItemArrow = 0,
    kDragItemWarp,
    kDragItemSplitter,
} kDragItem;

@protocol DragItemDelegate <NSObject>

- (void)dragItemMoved:(kDragItem)itemType touch:(UITouch *)touch button:(DragButton *)button;
- (void)dragItemDropped:(kDragItem)itemType touch:(UITouch *)touch button:(DragButton *)button;

@end

@protocol DragButtonTouchProxy <NSObject>

- (void)forwardDragTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)forwardDragTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)forwardDragTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

@end


@interface DragButton : TouchNode <DragButtonTouchProxy>

@property (weak, nonatomic) id<DragItemDelegate> delegate;

+ (DragButton *)buttonWithItemType:(kDragItem)itemType defaultSprite:(CCSprite *)defaultSprite selectedSprite:(CCSprite *)selectedSprite dragItemSprite:(CCSprite *)itemSprite delegate:(id<DragItemDelegate>)delegate;

@end
