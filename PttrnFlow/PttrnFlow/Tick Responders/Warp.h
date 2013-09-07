//
//  Warp.h
//  PttrnFlow
//
//  Created by John Saba on 7/16/13.
//
//

#import "DragCellNode.h"
#import "TickResponder.h"

@interface Warp : DragCellNode <TickResponder>

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode dragItemDelegate:(id<DragItemDelegate>)delegate cell:(GridCoord)cell;

@end
