//
//  NSArray+PFLCompareObjects.h
//  PttrnFlow
//
//  Created by John Saba on 3/17/14.
//
//

#import "cocos2d.h"

@protocol PFLCompareObjectsDelegate <NSObject>

- (BOOL)isEqualToObject:(id)object;

@end

@interface NSArray (PFLCompareObjects) <PFLCompareObjectsDelegate>

- (BOOL)isEqualToObject:(id)object;
- (BOOL)hasSameNumberOfSameObjects:(NSArray *)objects;

@end
