//
//  GridUtils.h
//  SequencerGame
//
//  Created by John Saba on 1/19/13.
//
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "cocos2d.h"

typedef struct
{
    int x;
    int y;
    
} GridCoord;

// helper function to create a GridCoord
static inline GridCoord
GridCoordMake(const int x, const int y)
{
	GridCoord gridCoord = {x, y};
	return gridCoord;
}


@interface GridUtils : NSObject
{
    
}

#pragma mark - conversions

// absolute position on a grid for grid coordinate, bottom left
+ (CGPoint) absolutePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

+ (CGPoint)relativePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize;   

// grid coordinate for absolute position on a grid
+ (GridCoord) gridCoordForAbsolutePosition:(CGPoint)position unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

// grid coordinate for relative position on a grid
+ (GridCoord)gridCoordForRelativePosition:(CGPoint)position unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

// absolute position made for sprite (anchor point middle) on a grid for grid coordinate
+ (CGPoint) absoluteSpritePositionForGridCoord:(GridCoord)coord unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

+ (GridCoord)gridCoordFromSize:(CGSize)size;

#pragma mark - tiled map editor

// translate a standard gridcoord [(1,1) == bottom left] to tiled grid coord [(0,0) == top left]
+ (GridCoord)tiledGridCoordForGameGridCoord:(GridCoord)coord tileMapHeight:(CGFloat)height;

// translate cocos2d position [(0.0, 0.0) == bottom left] to tiled grid coord [(0,0) == top left];
+ (GridCoord)tiledGridCoordForPosition:(CGPoint)position tileMap:(CCTMXTiledMap *)tileMap origin:(CGPoint)origin;

// translate cocos2d position [(0.0, 0.0) == bottom left] to a tiled format coord [(0.0, 0.0) == top left]
+ (CGPoint)tiledCoordForPosition:(CGPoint)position tileMap:(CCTMXTiledMap *)tileMap origin:(CGPoint)origin;

#pragma mark - drawing

// draws grid lines, call in layer's draw method
+ (void)drawGridWithSize:(GridCoord)gridSize unitSize:(CGFloat)unitSize origin:(CGPoint)origin;

#pragma mark - distance

// number of cell steps to get from starting coord to ending coord, no diagonal path allowed
+ (int)numberOfStepsBetweenStart:(GridCoord)start end:(GridCoord)end;

#pragma mark - directions

// direction by comparing starting coord and ending coord, no diagonal path allowed
+ (kDirection)directionFromStart:(GridCoord)start end:(GridCoord)end;

+ (kDirection)oppositeDirection:(kDirection)direction;

+ (GridCoord)stepInDirection:(kDirection)direction fromCell:(GridCoord)cell;

+ (NSString *)directionStringForDirection:(kDirection)direction;

+ (kDirection)directionForString:(NSString *)string;

#pragma mark - compare

// checks for gridcoords as same coordinate
+ (BOOL)isCell:(GridCoord)firstCell equalToCell:(GridCoord)secondCell;

+ (BOOL)isCellInBounds:(GridCoord)cell gridSize:(GridCoord)size;

#pragma mark - perform

// iterate between a path strictly up/down or left/right performing block with cell
+ (void)performBlockBetweenFirstCell:(GridCoord)firstCell
                          secondCell:(GridCoord)secondCell
                               block:(void (^)(GridCoord cell, kDirection direction))block;


@end
