//
//  TickChannel.h
//  PttrnFlow
//
//  Created by John Saba on 6/23/13.
//
//

#import "cocos2d.h"
#import "GameConstants.h"
#import "GridUtils.h"


@interface TickChannel : NSObject

@property (assign) int channel;
@property (assign) kDirection startingDirection;
@property (assign) kDirection currentDirection;
@property (assign) GridCoord startingCell;
@property (assign) GridCoord currentCell;

- (id)initWithChannel:(int)channel startingDirection:(kDirection)direction startingCell:(GridCoord)cell;
- (GridCoord)nextCell;
- (void)update:(NSMutableArray *)events;

@end
