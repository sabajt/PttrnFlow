//
//  DragItemDelegate.h
//  PttrnFlow
//
//  Created by John Saba on 7/4/13.
//
//

#import <Foundation/Foundation.h>

// types of game objects that the delegate should know how to create
typedef enum
{
    kDragItemArrow = 0,
    kDragItemWarp,
    kDragItemSplitter,
} kDragItem;

@protocol DragItemDelegate <NSObject>

- (void)dragItemMoved:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender;
- (void)dragItemDropped:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender;

@optional

- (void)dragItemBegan:(kDragItem)itemType touch:(UITouch *)touch sender:(id)sender;
- (CGFloat)dragItemScaleFactor;

@end
