//
//  CellNode.h
//  FishSet
//
//  Created by John Saba on 2/3/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"

@class CellNode;

@interface CellNode : CCNode 

@property (strong, nonatomic) CCSprite *sprite;
@property (assign) GridCoord cell;

- (CCSprite *)createAndCenterSpriteNamed:(NSString *)name; // returns sprite with image name, centered in content bounds
- (void)alignSprite:(kDirection)direction;

@end
