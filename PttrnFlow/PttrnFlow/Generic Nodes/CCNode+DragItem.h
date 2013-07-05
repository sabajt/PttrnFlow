//
//  CCNode+DragItem.h
//  PttrnFlow
//
//  Created by John Saba on 7/4/13.
//
//

#import "cocos2d.h"
#import "DragItemDelegate.h"

@interface CCNode (DragItem)

- (void)dragTouchBegan:(UITouch *)touch
            dragSprite:(CCSprite *)dragSprite;

- (void)dragTouchMoved:(UITouch *)touch
            dragSprite:(CCSprite *)dragSprite
      dragItemDelegate:(id<DragItemDelegate>)delegate
              itemType:(kDragItem)itemType
                sender:(id)sender;

- (void)dragTouchEnded:(UITouch *)touch
            dragSprite:(CCSprite *)dragSprite
      dragItemDelegate:(id<DragItemDelegate>)delegate
              itemType:(kDragItem)itemType
                sender:(id)sender;

- (void)styleForDragging:(BOOL)shouldStyleForDragging;

@end
