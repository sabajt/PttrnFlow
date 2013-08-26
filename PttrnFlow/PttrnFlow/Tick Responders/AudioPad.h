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

- (id)initWithCell:(GridCoord)cell;

@end
