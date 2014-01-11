//
//  NSObject+AudioDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 1/10/14.
//
//

#import <Foundation/Foundation.h>

@class Coord;

@interface NSObject (AudioDispatcher)

- (NSArray *)hitRespondersAtCoord:(Coord *)coord responders:(NSArray *)responders;

@end
