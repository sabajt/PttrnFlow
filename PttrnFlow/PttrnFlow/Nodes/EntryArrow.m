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

- (id)initWithEntry:(NSMutableDictionary *)entry tiledMap:(CCTMXTiledMap *)tiledMap puzzleOrigin:(CGPoint)origin
{
    self = [super init];
    if (self) {
        self.cell = [tiledMap gridCoordForObject:entry];
        
        self.sprite = [SpriteUtils spriteWithTextureKey:kImageStartArrow];
        NSString *directionName = [CCTMXTiledMap objectPropertyNamed:@"direction" object:entry];
        kDirection direction = [SGTiledUtils directionNamed:directionName];
        
        self.sprite.rotation = [SpriteUtils degreesForDirection:direction];
        [self alignSprite:[GridUtils oppositeDirection:direction]];
        [self addChild:self.sprite];
        
        self.position = [GridUtils absolutePositionForGridCoord:self.cell unitSize:kSizeGridUnit origin:origin];
    }
    return self;
}

@end
