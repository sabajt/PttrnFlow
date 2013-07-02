//
//  Arrow.h
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//


#import "SynthCellDragNode.h"
#import "TickResponder.h"

@interface Arrow : SynthCellDragNode <TickResponder>

@property (assign) kDirection facing;

- (id)initWithArrow:(NSMutableDictionary *)arrow tiledMap:(CCTMXTiledMap *)tiledMap synth:(id<SoundEventReceiver>)synth dragProxy:(id<DragButtonTouchProxy>)dragProxy;
- (id)initWithSynth:(id<SoundEventReceiver>)synth cell:(GridCoord)cell facing:(kDirection)facing dragProxy:(id<DragButtonTouchProxy>)dragProxy;

@end
