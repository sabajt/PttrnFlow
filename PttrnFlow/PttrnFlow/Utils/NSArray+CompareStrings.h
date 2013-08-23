//
//  NSArray+CompareStrings.h
//  PttrnFlow
//
//  Created by John Saba on 6/26/13.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (CompareStrings)

// checks if array contains only strings
- (BOOL)hasOnlyStrings;

// evaluates true if both arrays have same strings and same number of occurances of those strings.
// if either array contains non-string objects, evaluates false.
// method is recursive, so comparing 2 empty arrays evaluates true.
// order does not matter.
- (BOOL)hasSameNumberOfSameStrings:(NSArray *)incoming;

// array contains at least one occurance of given string.
- (BOOL)hasString:(NSString *)string;

@end
