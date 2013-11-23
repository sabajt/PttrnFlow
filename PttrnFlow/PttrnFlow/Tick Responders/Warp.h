//
//  Warp.h
//  PttrnFlow
//
//  Created by John Saba on 7/16/13.
//
//

#import "DragCellNode.h"
#import "AudioResponder.h"

@interface Warp : DragCellNode <AudioResponder>

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode dragItemDelegate:(id<DragItemDelegate>)delegate cell:(GridCoord)cell;

@end
