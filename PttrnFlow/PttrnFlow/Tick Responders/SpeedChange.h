//
//  SpeedChange.h
//  PttrnFlow
//
//  Created by John Saba on 8/26/13.
//
//

#import "DragCellNode.h"
#import "AudioResponder.h"

@interface SpeedChange : DragCellNode <AudioResponder>

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode Cell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate speed:(NSString *)speed;

@property (copy, nonatomic) NSString *speed;

@end
