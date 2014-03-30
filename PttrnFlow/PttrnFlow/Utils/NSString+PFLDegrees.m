//
//  NSString+Degrees.m
//  PttrnFlow
//
//  Created by John Saba on 1/20/14.
//
//

#import "NSString+PFLDegrees.h"
#import "PFLGameConstants.h"

@implementation NSString (PFLDegrees)

- (CGFloat)degrees
{
    if ([self isEqualToString:kDirectionUp]) {
        return 0.0;
    }
    else if ([self isEqualToString:kDirectionRight]) {
        return 90.0;
    }
    else if ([self isEqualToString:kDirectionDown]) {
        return 180.0;
    }
    else if ([self isEqualToString:kDirectionLeft]) {
        return 270.0;
    }
    CCLOG(@"warning: %@ is an invalid direction, returning 0", self);
    return 0;
}

@end
