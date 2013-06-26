//
//  NSArray+CompareStrings.m
//  PttrnFlow
//
//  Created by John Saba on 6/26/13.
//
//

#import "NSArray+CompareStrings.h"

@implementation NSArray (CompareStrings)

- (BOOL)containsSameStrings:(NSArray *)compare
{
    // first check that both arrays are same length and only contain strings
    if (!([self containsOnlyStrings] && [compare containsOnlyStrings]) && (self.count == compare.count)) {
        return NO;
    }
    
    // cross check that both arrays contain the same strings
    for (NSString *str in self) {
        NSUInteger index = [compare indexOfObjectPassingTest:^BOOL(NSString *compareStr, NSUInteger idx, BOOL *stop) {
            return [str isEqualToString:compareStr];
        }];
        if (index == NSNotFound) {
            return NO;
        }
    }
    for (NSString *compareStr in compare) {
        NSUInteger index = [self indexOfObjectPassingTest:^BOOL(NSString *str, NSUInteger idx, BOOL *stop) {
            return [compareStr isEqualToString:str];
        }];
        if (index == NSNotFound) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)containsOnlyStrings
{
    for (id obj in self) {
        if (![obj isKindOfClass:[NSString class]]) {
            return NO;
        }
    }
    return YES;
}

@end
