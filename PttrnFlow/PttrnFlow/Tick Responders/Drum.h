//
//  Drum.h
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "GameNode.h"
#import "AudioResponder.h"

@interface Drum : GameNode <AudioResponder>

- (id)initWithDrum:(NSMutableDictionary *)drum batchNode:(CCSpriteBatchNode *)batchNode tiledMap:(CCTMXTiledMap *)tiledMap;

@end
