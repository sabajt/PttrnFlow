//
//  NSArray+PFLCompareObjects.m
//  PttrnFlow
//
//  Created by John Saba on 3/17/14.
//
//

#import "NSArray+PFLCompareObjects.h"

@implementation NSArray (PFLCompareObjects)

- (BOOL)isEqualToObject:(id)object
{
    CCLOG(@"Warning: array using category NSArray+PFLCompareObjects does not implement isEqualToObject:");
    return [self isEqual:object];
}

- (BOOL)hasSameNumberOfSameObjects:(NSArray *)objects
{
    if (self.count == 0) {
        if (objects.count == 0) {
            return YES;
        }
        return NO;
    }
    
    NSObject *targetObject = [self firstObject];
    NSUInteger matchIndex = [objects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([obj isEqualToObject:targetObject]);
    }];
    if (matchIndex == NSNotFound) {
        return NO;
    }
    
    NSMutableArray *mutableSelf = [NSMutableArray arrayWithArray:self];
    NSMutableArray *mutableTargets = [NSMutableArray arrayWithArray:objects];
    [mutableSelf removeObjectAtIndex:0];
    [mutableTargets removeObjectAtIndex:matchIndex];
    
    return [[NSArray arrayWithArray:mutableSelf] hasSameNumberOfSameObjects:[NSArray arrayWithArray:mutableTargets]];
}

@end
