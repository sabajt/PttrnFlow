//
//  Coord.h
//  PttrnFlow
//
//  Created by John Saba on 1/3/14.
//
//

#import <Foundation/Foundation.h>
#import "PFLGameConstants.h"

FOUNDATION_EXPORT NSString *const kNeighborLeft;
FOUNDATION_EXPORT NSString *const kNeighborRight;
FOUNDATION_EXPORT NSString *const kNeighborAbove;
FOUNDATION_EXPORT NSString *const kNeighborBelow;

@interface PFLCoord : NSObject

@property (assign) NSInteger x;
@property (assign) NSInteger y;

+ (NSArray *)coordsFromArrays:(NSArray *)arrays;
+ (id)coordWithX:(NSInteger)x Y:(NSInteger)y;

#pragma mark - position

+ (PFLCoord *)coordForRelativePosition:(CGPoint)position;
+ (PFLCoord *)coordForRelativePosition:(CGPoint)position unitSize:(CGFloat)unitSize;
- (CGPoint)relativePosition;
- (CGPoint)relativePositionWithUnitSize:(CGFloat)unitSize;
- (CGPoint)relativeMidpoint;
- (CGPoint)relativeMidpointWithUnitSize:(CGFloat)unitSize;

#pragma mark - compare

+ (PFLCoord *)maxCoord:(NSArray *)coords;
- (BOOL)isEqualToCoord:(PFLCoord *)coord;
- (BOOL)isCoordInGroup:(NSArray *)coords;

#pragma mark - context

+ (NSArray *)findNeighborPairs:(NSArray *)coords;
- (NSDictionary *)neighbors;
- (BOOL)isNeighbor:(PFLCoord *)coord;
- (BOOL)isAbove:(PFLCoord *)coord;
- (BOOL)isBelow:(PFLCoord *)coord;
- (BOOL)isLeft:(PFLCoord *)coord;
- (BOOL)isRight:(PFLCoord *)coord;
- (PFLCoord *)stepInDirection:(NSString *)direction;

#pragma mark - debug

- (NSString *)stringRep;

@end
