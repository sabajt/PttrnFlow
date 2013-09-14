//
//  Drum.h
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "GameNode.h"
#import "TickResponder.h"

@interface Drum : GameNode <TickResponder>

- (id)initWithDrum:(NSMutableDictionary *)drum batchNode:(CCSpriteBatchNode *)batchNode tiledMap:(CCTMXTiledMap *)tiledMap;

@end
