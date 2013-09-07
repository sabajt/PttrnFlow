//
//  DragCellNode.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "CellNode.h"
#import "DragItemDelegate.h"


@interface DragCellNode : CellNode

@property (assign) BOOL cancelTouch;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate dragSprite:(CCSprite *)dragSprite dragItemType:(kDragItem)dragItemType;

@end
