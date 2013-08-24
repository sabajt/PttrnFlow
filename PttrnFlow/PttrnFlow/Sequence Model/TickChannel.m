//
//  TickChannel.m
//  PttrnFlow
//
//  Created by John Saba on 6/23/13.
//
//

#import "TickChannel.h"
#import "TickDispatcher.h"
#import "TickEvent.h"
#import "ExitEvent.h"
#import "DirectionEvent.h"

@implementation TickChannel

- (id)initWithChannel:(NSString *)channel startingDirection:(kDirection)direction startingCell:(GridCoord)cell
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

// some events cause changes in channel state
- (void)update:(NSArray *)events
{
    for (TickEvent *event in events) {
        
        // stop if exit event
        if ([event isKindOfClass:[ExitEvent class]]) {
            self.hasStopped = YES;
        }
        // change direction if direction event
        if ([event isKindOfClass:[DirectionEvent class]]) {
            DirectionEvent *directionEvent = (DirectionEvent *)event;
            self.currentDirection = [GridUtils directionForString:directionEvent.direction];
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
