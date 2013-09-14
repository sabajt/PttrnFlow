//
//  Tone.h
//  SequencerGame
//
//  Created by John Saba on 5/4/13.
//
//

#import "GameNode.h"
#import "TickResponder.h"

@interface Tone : GameNode <TickResponder>

@property (copy, nonatomic) NSString *midiValue;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode tone:(NSMutableDictionary *)tone tiledMap:(CCTMXTiledMap *)tiledMap;

@end
