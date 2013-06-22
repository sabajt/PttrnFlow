//
//  Arrow.h
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//


#import "SynthCellNode.h"
#import "TickResponder.h"

@interface Arrow : SynthCellNode <TickResponder>

@property (assign) kDirection facing;

- (id)initWithArrow:(NSMutableDictionary *)arrow tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin synth:(id<SoundEventReceiver>)synth;

@end
