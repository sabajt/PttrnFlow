//
//  Tone.h
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//

#import "SynthCellNode.h"
#import "TickResponder.h"

@interface Tone : SynthCellNode <TickResponder>

@property (assign) int midiValue;

- (id)initWithTone:(NSMutableDictionary *)tone tiledMap:(CCTMXTiledMap *)tiledMap synth:(id<SoundEventReceiver>)synth;

@end
