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
@property (copy, nonatomic) NSString *synthType;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode tone:(NSMutableDictionary *)tone tiledMap:(CCTMXTiledMap *)tiledMap;

@end
