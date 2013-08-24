//
//  Arrow.h
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//


#import "DragCellNode.h"
#import "TickResponder.h"

@interface Arrow : DragCellNode <TickResponder>

@property (assign) kDirection facing;

- (id)initWithArrow:(NSMutableDictionary *)arrow tiledMap:(CCTMXTiledMap *)tiledMap dragItemDelegate:(id<DragItemDelegate>)delegate;
- (id)initWithCell:(GridCoord)cell facing:(kDirection)facing dragItemDelegate:(id<DragItemDelegate>)delegate;

@end
