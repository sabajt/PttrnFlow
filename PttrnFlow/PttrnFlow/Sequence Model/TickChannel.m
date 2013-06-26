//
//  TickChannel.m
//  PttrnFlow
//
//  Created by John Saba on 6/23/13.
//
//

#import "TickChannel.h"
#import "TickDispatcher.h"

@implementation TickChannel

- (id)initWithChannel:(int)channel startingDirection:(kDirection)direction startingCell:(GridCoord)cell
{
    self = [super init];
    if (self) {
        self.channel = channel;
        self.startingDirection = direction;
        self.startingCell = cell;
        self.hasStopped = NO;
    }
    return self;
}

- (GridCoord)nextCell
{
    return [GridUtils stepInDirection:self.currentDirection fromCell:self.currentCell];
}

- (void)update:(NSMutableArray *)events
{
    for (NSString *event in events) {
        
        // stop for exit event
        if ([event isEqualToString:kExitEvent]) {
            self.hasStopped = YES;
        }
        // change direction for arrows
        if ([TickDispatcher isArrowEvent:event]) {
            self.currentDirection = [GridUtils directionForString:event];
        }
    }
}

- (void)reset
{
    self.currentCell = self.startingCell;
    self.currentDirection = self.startingDirection;
    self.hasStopped = NO;
}

@end
