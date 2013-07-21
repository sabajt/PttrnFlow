//
//  SynthCellDragNode.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "SynthCellNode.h"
#import "DragItemDelegate.h"


@interface SynthCellDragNode : SynthCellNode

@property (assign) BOOL cancelTouch;

- (id)initWithSynth:(id<SoundEventReceiver>)synth dragItemDelegate:(id<DragItemDelegate>)delegate dragSprite:(CCSprite *)dragSprite dragItemType:(kDragItem)dragItemType;

@end
