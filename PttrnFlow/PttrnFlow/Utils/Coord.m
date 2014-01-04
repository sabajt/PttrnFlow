//
//  Coord.m
//  PttrnFlow
//
//  Created by John Saba on 1/3/14.
//
//

#import "Coord.h"

NSString *const kNeighborLeft = @"left";
NSString *const kNeighborRight = @"right";
NSString *const kNeighborAbove = @"above";
NSString *const kNeighborBelow = @"below";

@implementation Coord

+ (id)coordWithX:(NSInteger)x Y:(NSInteger)y
{
    return [[Coord alloc] initWithX:x Y:y];
}

- (id)initWithX:(NSInteger)x Y:(NSInteger)y
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

#pragma mark - compare

- (BOOL)isEqualToCoord:(Coord *)coord
{
    return ((self.x == coord.x) && (self.y == coord.y));
}

#pragma mark - context

- (NSDictionary *)neighbors
{
    return @{kNeighborLeft : [Coord coordWithX:self.x - 1 Y:self.y],
             kNeighborRight : [Coord coordWithX:self.x + 1 Y:self.y],
             kNeighborAbove : [Coord coordWithX:self.x Y:self.y + 1],
             kNeighborBelow : [Coord coordWithX:self.x Y:self.y - 1]};
}

- (BOOL)isNeighbor:(Coord *)coord
{
    NSUInteger index = [[[self neighbors] allValues] indexOfObjectPassingTest:^BOOL(Coord *neighbor, NSUInteger idx, BOOL *stop) {
        return [coord isEqualToCoord:neighbor];
    }];
    return index != NSNotFound;
}

+ (NSArray *)findNeighborPairs:(NSArray *)coords
{
    return [Coord findNeighborPairs:coords existingPairs:[NSMutableArray array]];
}

+ (NSArray *)findNeighborPairs:(NSArray *)coords existingPairs:(NSMutableArray *)pairs
{
    if (coords.count == 2) {
        Coord *c1 = coords[0];
        Coord *c2 = coords[1];
        if ([c1 isNeighbor:c2]) {
            [pairs addObject:coords];
        }
        else return pairs;
    }
    
    Coord *baseCoord = [coords firstObject];
    NSArray *truncatedCoords = [coords subarrayWithRange:NSMakeRange(1, coords.count - 1)];
    for (Coord *c in truncatedCoords) {
        if ([baseCoord isNeighbor:c]) {
            [pairs addObject:@[baseCoord, c]];
        }
    }
    return [Coord findNeighborPairs:truncatedCoords existingPairs:pairs];
}


@end
