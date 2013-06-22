//
//  CellNode.h
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "TouchNode.h"
#import "GridUtils.h"

@class CellNode;

@interface CellNode : TouchNode

@property (strong, nonatomic) CCSprite *sprite;
@property (assign) GridCoord cell;

- (CCSprite *)createAndCenterSpriteNamed:(NSString *)name; // returns sprite with image name, centered in content bounds
- (void)alignSprite:(kDirection)direction;

@end
