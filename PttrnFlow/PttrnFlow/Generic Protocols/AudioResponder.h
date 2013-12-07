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

// tick responder must have a cell
- (GridCoord)responderCell;

// triggered on touch down or step
// responder may return an array of 1 or many fragments
- (NSArray *)audioHit:(NSInteger)bpm;

@optional

// triggered after touch up or after a step
// responder may return an aray of 1 or many fragments
- (NSArray *)audioRelease:(NSInteger)bpm;



@end
