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

// triggered on touch down or step
// responder should return an array of 1 or many fragments
- (NSArray *)audioHit:(NSInteger)bpm;

@optional

//triggered after touch up or step
// responder should return an aray of 1 or many fragments
- (NSArray *)audioRelease:(NSInteger)bpm;

// tick responder must have a cell
- (GridCoord)responderCell;

@end
