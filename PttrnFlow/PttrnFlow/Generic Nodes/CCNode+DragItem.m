//
//  CCNode+DragItem.m
//  PttrnFlow
//
//  Created by John Saba on 7/4/13.
//
//

#import "CCNode+DragItem.h"

@implementation CCNode (DragItem)

- (void)dragTouchBegan:(UITouch *)touch
            dragSprite:(CCSprite *)dragSprite
{        
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    dragSprite.position = touchPosition;
    dragSprite.visible = YES;
    [self styleForDragging:YES];
}

- (void)dragTouchMoved:(UITouch *)touch
            dragSprite:(CCSprite *)dragSprite
      dragItemDelegate:(id<DragItemDelegate>)delegate
              itemType:(kDragItem)itemType
                sender:(id)sender
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    dragSprite.position = touchPosition;
    [delegate dragItemMoved:itemType touch:touch sender:sender];
}

- (void)dragTouchEnded:(UITouch *)touch
            dragSprite:(CCSprite *)dragSprite
      dragItemDelegate:(id<DragItemDelegate>)delegate
              itemType:(kDragItem)itemType
                sender:(id)sender

{
    dragSprite.visible = NO;
    [delegate dragItemDropped:itemType touch:touch sender:sender];
    [self styleForDragging:NO];
}

- (void)styleForDragging:(BOOL)shouldStyleForDragging
{
    NSLog(@"warning: styleForDragging not implemented");
}

@end
