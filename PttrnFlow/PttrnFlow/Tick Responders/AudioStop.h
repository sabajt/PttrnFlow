//
//  AudioStop.h
//  PttrnFlow
//
//  Created by John Saba on 8/26/13.
//
//

#import "DragCellNode.h"
#import "AudioResponder.h"

@interface AudioStop : DragCellNode <AudioResponder>

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate;

@end
