//
//  NSArray+CompareNumbers.m
//  PttrnFlow
//
//  Created by John Saba on 7/28/13.
//
//

#import "NSArray+CompareNumbers.h"

@implementation NSArray (CompareNumbers)

- (BOOL)containsOnlyNumbers
{
    for (id obj in self) {
        if (![obj isKindOfClass:[NSNumber class]]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Public

- (NSNumber *)maxNumber
{
    if (![self containsOnlyNumbers]) {
        NSLog(@"warning: NSArray+CompareNumbers must be used on arrays containing only NSNumbers");
        return nil;
    }
    
    float xMax = -MAXFLOAT;
    for (NSNumber *number in self) {
        float x = number.floatValue;
        if (x > xMax) {
            xMax = x;
        }
    }
    return @(xMax);
}

@end
