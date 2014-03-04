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

// Triggered on touch down or step
// Handle glyph actions here, like highlighting / animation
// Responder may return and event to be processed as sound, or sequence logic
- (TickEvent *)audioHit:(CGFloat)beatDuration;

@optional

// triggered after touch up or after a step
- (NSArray *)audioRelease:(NSInteger)bpm;

@end
