//
//  NSArray+CompareStrings.m
//  PttrnFlow
//
//  Created by John Saba on 6/26/13.
//
//

#import "NSArray+CompareStrings.h"

@implementation NSArray (CompareStrings)

// checks if array contains only strings
- (BOOL)hasOnlyStrings
{
    for (id obj in self) {
        if (![obj isKindOfClass:[NSString class]]) {
            return NO;
        }
    }
    return YES;
}

// evaluates true if both arrays have same strings and same number of occurances of those strings.
// if either array contains non-string object, evaluates false.
// method is recursive, so comparing 2 empty arrays evaluates true.
// order does not matter.
- (BOOL)hasSameNumberOfSameStrings:(NSArray *)incoming
{
    // base case: we have succesfully matched every occurance of every string
    if (self.count == 0 && incoming.count == 0) {
        return YES;
    }
    
    // first check that both arrays are same length and only contain strings
    if (!([self hasOnlyStrings] && [incoming hasOnlyStrings]) && (self.count == incoming.count)) {
        return NO;
    }
    
    NSString *targetString = [self firstObject];
    NSUInteger targetIndex = [incoming indexOfObjectPassingTest:^BOOL(NSString *str, NSUInteger idx, BOOL *stop) {
        return [str isEqualToString:targetString];
    }];
    
    // no match for first string, test fails
    if (targetIndex == NSNotFound) {
        return NO;
    }
    
    // if we've found a match, remove matches in mutable copies of both arrays
    NSMutableArray *mutableSelf = [NSMutableArray arrayWithArray:self];
    NSMutableArray *mutableIncoming = [NSMutableArray arrayWithArray:incoming];
    [mutableSelf removeObjectAtIndex:0];
    [mutableIncoming removeObjectAtIndex:targetIndex];
    
    // recursive call to new, shortened arrays
    return [mutableSelf hasSameNumberOfSameStrings:mutableIncoming];
}

// array contains at least one occurance of given string.
- (BOOL)hasString:(NSString *)string
{
    for (id obj in self) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([(NSString *)obj isEqualToString:string]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
