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
#import "SpeedChangeEvent.h"

@implementation TickChannel

- (id)initWithChannel:(NSString *)channel startingDirection:(kDirection)direction startingCell:(Coord *)cell
{
    self = [super init];
    if (self) {
        self.channel = channel;
        self.startingDirection = direction;
        self.startingCell = cell;
        self.hasStopped = NO;
        self.speed = @"1X";
    }
    return self;
}

- (Coord *)nextCell
{
    return [self.currentCell stepInDirection:self.currentDirection];
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
//            self.currentDirection = [GridUtils directionForString:directionEvent.direction];
            self.currentDirection = [Coord directionForString:directionEvent.direction];
        }
        // change speed
        if ([event isKindOfClass:[SpeedChangeEvent class]]) {
            SpeedChangeEvent *speedChangeEvent = (SpeedChangeEvent *)event;
            self.speed = speedChangeEvent.speed;
        }
    }
}

- (void)reset
{
    self.currentCell = self.startingCell;
    self.currentDirection = self.startingDirection;
    self.hasStopped = NO;
    self.speed = @"1X";
}

@end
