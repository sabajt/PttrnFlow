//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "CellNode.h"
#import "TickResponder.h"

@interface AudioPad : CellNode <TickResponder>

// TODO: audio pad doesn't actually use batch node, but it probably should, - rendering the sprite creation is probably expensive
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode cell:(GridCoord)cell;

@end
