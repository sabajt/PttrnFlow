//
//  AudioResponder.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"

@class TickEvent;

@protocol AudioResponder <NSObject>

// responder should return an array of fragments (often this will be just 1 fragment)
- (NSArray *)audioHit:(NSInteger)bpm;

// TODO: this could also return a value that could trigger more events
- (void)audioRelease:(NSInteger)bpm;

// tick responder must have a cell
- (GridCoord)responderCell;

@end
