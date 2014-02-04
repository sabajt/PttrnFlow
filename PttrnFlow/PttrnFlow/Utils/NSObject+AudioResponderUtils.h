//
//  NSObject+AudioResponderUtils.h
//  PttrnFlow
//
//  Created by John Saba on 1/10/14.
//
//

#import <Foundation/Foundation.h>

@class Coord;

@interface NSObject (AudioResponderUtils)

- (NSArray *)responders:(NSArray *)responders atCoord:(Coord *)coord;

@end
