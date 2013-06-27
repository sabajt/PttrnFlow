//
//  Drum.h
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "SynthCellNode.h"
#import "TickResponder.h"

@interface Drum : SynthCellNode <TickResponder>

- (id)initWithDrum:(NSMutableDictionary *)drum tiledMap:(CCTMXTiledMap *)tiledMap synth:(id<SoundEventReceiver>)synth;

@end
