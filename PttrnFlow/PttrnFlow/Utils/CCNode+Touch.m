//
//  CCNode+Touch.m
//  PttrnFlow
//
//  Created by John Saba on 6/9/13.
//
//

#import "CCNode+Touch.h"

@implementation CCNode (Touch)

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    return (CGRectContainsPoint(rect, touchPosition));
}

@end
