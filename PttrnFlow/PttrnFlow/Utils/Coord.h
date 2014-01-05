//
//  Coord.h
//  PttrnFlow
//
//  Created by John Saba on 1/3/14.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kNeighborLeft;
FOUNDATION_EXPORT NSString *const kNeighborRight;
FOUNDATION_EXPORT NSString *const kNeighborAbove;
FOUNDATION_EXPORT NSString *const kNeighborBelow;

@interface Coord : NSObject

@property (assign) NSInteger x;
@property (assign) NSInteger y;

+ (id)coordWithX:(NSInteger)x Y:(NSInteger)y;

#pragma mark - position

- (CGPoint)relativePosition;
- (CGPoint)relativePositionWithUnitSize:(CGFloat)unitSize;
- (CGPoint)relativeMidpoint;
- (CGPoint)relativeMidpointWithUnitSize:(CGFloat)unitSize;

#pragma mark - compare

- (BOOL)isEqualToCoord:(Coord *)coord;

#pragma mark - context

+ (NSArray *)findNeighborPairs:(NSArray *)coords;
- (NSDictionary *)neighbors;
- (BOOL)isNeighbor:(Coord *)coord;
- (BOOL)isAbove:(Coord *)coord;
- (BOOL)isBelow:(Coord *)coord;
- (BOOL)isLeft:(Coord *)coord;
- (BOOL)isRight:(Coord *)coord;

@end
