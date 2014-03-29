//
//  PttrnFlow_Tests.m
//  PttrnFlow Tests
//
//  Created by John Saba on 1/4/14.
//
//

#import <XCTest/XCTest.h>
#import "PFLCoord.h"

@interface PttrnFlow_Tests : XCTestCase

@end

@implementation PttrnFlow_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoordNeighbors
{
    // testing neigbors
    PFLCoord *c1_1 = [PFLCoord coordWithX:1 Y:1];
    PFLCoord *c1_3 = [PFLCoord coordWithX:1 Y:3];
    PFLCoord *c1_4 = [PFLCoord coordWithX:1 Y:4];
    PFLCoord *c2_2 = [PFLCoord coordWithX:2 Y:2];
    PFLCoord *c2_3 = [PFLCoord coordWithX:2 Y:3];
    PFLCoord *c3_2 = [PFLCoord coordWithX:3 Y:2];
    PFLCoord *c3_4 = [PFLCoord coordWithX:3 Y:4];
    PFLCoord *c4_1 = [PFLCoord coordWithX:4 Y:1];
    PFLCoord *c4_2 = [PFLCoord coordWithX:4 Y:2];
    PFLCoord *c4_3 = [PFLCoord coordWithX:4 Y:3];
    PFLCoord *c5_2 = [PFLCoord coordWithX:5 Y:2];
    
    NSArray *pairs = [PFLCoord findNeighborPairs:@[c1_1, c1_3, c1_4, c2_2, c2_3, c3_2, c3_4, c4_1, c4_2, c4_3, c5_2]];
    XCTAssert(pairs.count == 8, @"Coord findNeighborPairs did not find expected number of pairs");
}

@end
