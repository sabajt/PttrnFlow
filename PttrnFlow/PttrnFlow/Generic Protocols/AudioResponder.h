//
//  AudioResponder.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import <Foundation/Foundation.h>
#import "Coord.h"

@class TickEvent;

@protocol AudioResponder <NSObject>

// responder must have a cell
- (Coord *)audioCell;

// triggered on touch down or step
// responder may return an array of 1 or many fragments
// TODO: refactor responder's implementations to just return events
- (TickEvent *)audioHit:(NSInteger)bpm;

@optional

// triggered after touch up or after a step
// responder may return an aray of 1 or many fragments
- (NSArray *)audioRelease:(NSInteger)bpm;

@end
