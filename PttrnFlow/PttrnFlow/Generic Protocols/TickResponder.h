//
//  TickResponder.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"

@class TickEvent;

@protocol TickResponder <NSObject>

// responder should return an array of fragments (often this will be just 1 fragment)
- (NSArray *)tick:(NSInteger)bpm;

// TODO: this could also return a value that could trigger more events
- (void)afterTick:(NSInteger)bpm;

// tick responder must have a cell
- (GridCoord)responderCell;

@end
