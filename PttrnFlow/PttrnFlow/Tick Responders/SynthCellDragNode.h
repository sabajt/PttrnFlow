//
//  SynthCellDragNode.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "SynthCellNode.h"
#import "DragButton.h"

@interface SynthCellDragNode : SynthCellNode

- (id)initWithSynth:(id<SoundEventReceiver>)synth dragProxy:(id<DragButtonTouchProxy>)dragProxy;

@end
