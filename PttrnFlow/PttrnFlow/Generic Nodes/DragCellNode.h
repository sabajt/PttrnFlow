//
//  DragCellNode.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "GameNode.h"
#import "DragItemDelegate.h"


@interface DragCellNode : GameNode

@property (assign) BOOL cancelTouch;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate dragSprite:(CCSprite *)dragSprite dragItemType:(kDragItem)dragItemType;

@end
