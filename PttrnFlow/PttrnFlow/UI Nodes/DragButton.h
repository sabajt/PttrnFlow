//
//  DragButton.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "TouchNode.h"
#import "DragItemDelegate.h"


@interface DragButton : TouchNode <TouchNodeDelegate>

@property (weak, nonatomic) id<DragItemDelegate> dragItemDelegate;

+ (DragButton *)buttonWithBatchNode:(CCSpriteBatchNode *)batchNode itemType:(kDragItem)itemType defaultSprite:(CCSprite *)defaultSprite selectedSprite:(CCSprite *)selectedSprite dragItemSprite:(CCSprite *)itemSprite delegate:(id<DragItemDelegate>)delegate;

@end
