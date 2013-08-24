//
//  Tone.h
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//

#import "CellNode.h"
#import "TickResponder.h"

@interface Tone : CellNode <TickResponder>

@property (assign) int midiValue;

- (id)initWithTone:(NSMutableDictionary *)tone tiledMap:(CCTMXTiledMap *)tiledMap;

@end
