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

@property (copy, nonatomic) NSString *channel;
@property (assign) kDirection startingDirection;
@property (assign) kDirection currentDirection;
@property (assign) GridCoord startingCell;
@property (assign) GridCoord currentCell;
@property (assign) BOOL hasStopped;
@property (copy, nonatomic) NSString *speed;

- (id)initWithChannel:(NSString *)channel startingDirection:(kDirection)direction startingCell:(GridCoord)cell;
- (GridCoord)nextCell;
- (void)update:(NSArray *)events;
- (void)reset;

@end
