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

@property (copy, nonatomic) NSString *midiValue;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode tone:(NSMutableDictionary *)tone tiledMap:(CCTMXTiledMap *)tiledMap;

@end
