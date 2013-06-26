//
//  NSArray+CompareStrings.h
//  PttrnFlow
//
//  Created by John Saba on 6/26/13.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (CompareStrings)

- (BOOL)containsSameStrings:(NSArray *)compare;
- (BOOL)containsOnlyStrings;

@end
