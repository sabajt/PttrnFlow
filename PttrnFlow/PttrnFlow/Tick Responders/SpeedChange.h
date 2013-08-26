//
//  SpeedChange.h
//  PttrnFlow
//
//  Created by John Saba on 8/26/13.
//
//

#import "DragCellNode.h"
#import "TickResponder.h"

@interface SpeedChange : DragCellNode <TickResponder>

- (id)initWithCell:(GridCoord)cell dragItemDelegate:(id<DragItemDelegate>)delegate speed:(NSString *)speed;

@property (copy, nonatomic) NSString *speed;

@end
