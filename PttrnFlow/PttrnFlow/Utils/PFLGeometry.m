//
//  PFGeometry.m
//  PttrnFlow
//
//  Created by John Saba on 1/5/14.
//
//

#import "PFLGeometry.h"

@implementation PFLGeometry

CGPoint CGMidPointMake(CGPoint p1, CGPoint p2)
{
    return CGPointMake( ( (p1.x + p2.x) / 2), ( (p1.y + p2.y) / 2) );
}

CGSize CGContainingSize(CGSize s1, CGSize s2)
{
    return CGSizeMake( fmaxf(s1.width, s2.width), fmaxf(s1.height, s2.height) );
}


@end
