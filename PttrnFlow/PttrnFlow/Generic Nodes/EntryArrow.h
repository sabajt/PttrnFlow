//
//  EntryArrow.h
//  PttrnFlow
//
//  Created by John Saba on 5/27/13.
//
//

#import "CellNode.h"

@interface EntryArrow : CellNode

- (id)initWithEntry:(NSMutableDictionary *)entry tiledMap:(CCTMXTiledMap *)tiledMap;

@end
