//
//  Coord.m
//  PttrnFlow
//
//  Created by John Saba on 1/3/14.
//
//

#import "Coord.h"

static CGFloat kDefaultUnitSize = 68.0;

NSString *const kNeighborLeft = @"left";
NSString *const kNeighborRight = @"right";
NSString *const kNeighborAbove = @"above";
NSString *const kNeighborBelow = @"below";

@implementation Coord

+ (NSArray *)coordsFromArrays:(NSArray *)arrays
{
    NSMutableArray *coords = [NSMutableArray array];
    for (NSArray *a in arrays) {
        [coords addObject:[Coord coordWithX:[a[0] integerValue] Y:[a[1] integerValue]]];
    }
    return [NSArray arrayWithArray:coords];
}

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

#pragma mark - position

+ (Coord *)coordForRelativePosition:(CGPoint)position
{
    return [Coord coordForRelativePosition:position unitSize:kDefaultUnitSize];
}

+ (Coord *)coordForRelativePosition:(CGPoint)position unitSize:(CGFloat)unitSize
{
    return [Coord coordWithX:floorf(position.x / unitSize) Y:floorf(position.y / unitSize)];
}

- (CGPoint)relativePosition
{
    return [self relativePositionWithUnitSize:kDefaultUnitSize];
}

- (CGPoint)relativePositionWithUnitSize:(CGFloat)unitSize
{
    return CGPointMake(self.x * unitSize, self.y * unitSize);
}

- (CGPoint)relativeMidpoint
{
    return [self relativeMidpointWithUnitSize:kDefaultUnitSize];
}

- (CGPoint)relativeMidpointWithUnitSize:(CGFloat)unitSize
{
    CGPoint position = [self relativePositionWithUnitSize:unitSize];
    return CGPointMake(position.x + unitSize / 2, position.y + unitSize / 2);
}

#pragma mark - compare

+ (Coord *)maxCoord:(NSArray *)coords
{
    NSInteger xMax = 0;
    NSInteger yMax = 0;

    for (Coord *c in coords) {
        xMax = MAX(xMax, c.x);
        yMax = MAX(yMax, c.y);
    }
    return [Coord coordWithX:xMax Y:yMax];
}

- (BOOL)isEqualToCoord:(Coord *)coord
{
    return ((self.x == coord.x) && (self.y == coord.y));
}

- (BOOL)isCoordInGroup:(NSArray *)coords
{
    for (Coord *c in coords) {
        if ([c isEqualToCoord:self]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - context

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
        return pairs;
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

- (BOOL)isAbove:(Coord *)coord
{
    Coord *above = [[coord neighbors] objectForKey:kNeighborAbove];
    return [self isEqualToCoord:above];
}

- (BOOL)isBelow:(Coord *)coord
{
    Coord *below = [[coord neighbors] objectForKey:kNeighborBelow];
    return [self isEqualToCoord:below];
}

- (BOOL)isLeft:(Coord *)coord
{
    Coord *left = [[coord neighbors] objectForKey:kNeighborLeft];
    return [self isEqualToCoord:left];
}

- (BOOL)isRight:(Coord *)coord
{
    Coord *right = [[coord neighbors] objectForKey:kNeighborRight];
    return [self isEqualToCoord:right];
}

- (Coord *)stepInDirection:(NSString *)direction
{
    if ([direction isEqualToString:kDirectionUp]) {
        return [self neighbors][kNeighborAbove];
    }
    else if ([direction isEqualToString:kDirectionRight]) {
        return [self neighbors][kNeighborRight];
    }
    else if ([direction isEqualToString:kDirectionDown]) {
        return [self neighbors][kNeighborBelow];
    }
    else if ([direction isEqualToString:kDirectionLeft]) {
        return [self neighbors][kNeighborLeft];
    }
    else {
        CCLOG(@"warning: unrecognized direction");
        return nil;
    }
}

#pragma mark - Debug

- (NSString *)stringRep
{
    return [NSString stringWithFormat:@"( %i, %i )", self.x, self.y];
}

@end
