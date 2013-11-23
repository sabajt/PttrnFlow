//
//  Arrow.h
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//


#import "DragCellNode.h"
#import "AudioResponder.h"

@interface Arrow : DragCellNode <AudioResponder>

@property (assign) kDirection facing;

- (id)initWithArrow:(NSMutableDictionary *)arrow batchNode:(CCSpriteBatchNode *)batchNode tiledMap:(CCTMXTiledMap *)tiledMap dragItemDelegate:(id<DragItemDelegate>)delegate;
- (id)initWithCell:(GridCoord)cell batchNode:(CCSpriteBatchNode *)batchNode  facing:(kDirection)facing dragItemDelegate:(id<DragItemDelegate>)delegate;

@end
