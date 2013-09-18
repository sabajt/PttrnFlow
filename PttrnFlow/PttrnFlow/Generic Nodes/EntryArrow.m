//
//  EntryArrow.m
//  PttrnFlow
//
//  Created by John Saba on 5/27/13.
//
//

#import "EntryArrow.h"
#import "CCTMXTiledMap+Utils.h"
#import "TextureUtils.h"
#import "SpriteUtils.h"
#import "SGTiledUtils.h"
#import "GridUtils.h"

@implementation EntryArrow

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode entry:(NSMutableDictionary *)entry tiledMap:(CCTMXTiledMap *)tiledMap
{
    GridCoord cell = [tiledMap gridCoordForObject:entry];
    self = [super initWithBatchNode:batchNode cell:cell];
    if (self) {
        [self setSpriteForFrameName:kImageStartArrow cell:cell];
        
        NSString *directionName = [CCTMXTiledMap objectPropertyNamed:@"direction" object:entry];
        kDirection direction = [SGTiledUtils directionNamed:directionName];
        self.sprite.rotation = [SpriteUtils degreesForDirection:direction];
    }
    return self;
}

@end
