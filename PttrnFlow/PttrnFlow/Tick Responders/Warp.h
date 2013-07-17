//
//  Warp.h
//  PttrnFlow
//
//  Created by John Saba on 7/16/13.
//
//

#import "SynthCellDragNode.h"
#import "TickResponder.h"

@interface Warp : SynthCellDragNode <TickResponder>

- (id)initWithSynth:(id<SoundEventReceiver>)synth dragItemDelegate:(id<DragItemDelegate>)delegate cell:(GridCoord)cell;

@end
