//
//  CCLayer+Positioning.m
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "CCLayer+Positioning.h"

@implementation CCLayer (Positioning)

- (CGPoint)relativePosition
{
    CGSize offset = CGSizeMake(self.contentSize.width * self.anchorPoint.x, self.contentSize.height * self.anchorPoint.y);
    return CGPointMake(self.position.x - offset.width, self.position.y - offset.height);
}

@end
