//
//  PFLAudioResponder.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import <Foundation/Foundation.h>
#import "PFLCoord.h"

@class PFLEvent;

@protocol PFLAudioResponder <NSObject>

// responder must have a cell
- (PFLCoord *)audioCell;

// Triggered on touch down or step
// Handle glyph actions here, like highlighting / animation
// Responder may return and event to be processed as sound, or sequence logic
- (PFLEvent *)audioHit:(CGFloat)beatDuration;

@optional

// triggered after touch up or after a step
- (NSArray *)audioRelease:(NSInteger)bpm;

@end
