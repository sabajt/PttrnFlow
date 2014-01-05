//
//  PFGeometry.m
//  PttrnFlow
//
//  Created by John Saba on 1/5/14.
//
//

#import "PFGeometry.h"

@implementation PFGeometry

CGPoint CGMidPointMake(CGPoint p1, CGPoint p2)
{
    return CGPointMake( ( (p1.x + p2.x) / 2), ( (p1.y + p2.y) / 2) );
}

@end
