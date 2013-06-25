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
        // change direction for arrows
        if ([TickDispatcher isArrowEvent:event]) {
            self.currentDirection = [GridUtils directionForString:event];
        }
    }
}

@end
