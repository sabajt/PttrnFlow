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

#pragma mark - compare

- (BOOL)isEqualToCoord:(Coord *)coord;

#pragma mark - context

- (NSDictionary *)neighbors;
- (BOOL)isNeighbor:(Coord *)coord;
+ (NSArray *)findNeighborPairs:(NSArray *)coords;

@end
