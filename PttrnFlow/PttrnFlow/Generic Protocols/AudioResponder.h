//
//  AudioResponder.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"

enum {
    AUDIO_CLUSTER_NONE = -1
};

@class TickEvent;

@protocol AudioResponder <NSObject>

// responder must have a cell
- (GridCoord)audioCell;

// triggered on touch down or step
// responder may return an array of 1 or many fragments
- (NSArray *)audioHit:(NSInteger)bpm;

//// triggered when a touch has been moved across a cell's borders
//- (void)audioTouchChangedToCell:(GridCoord)cell;

@optional

// triggered after touch up or after a step
// responder may return an aray of 1 or many fragments
- (NSArray *)audioRelease:(NSInteger)bpm;

// responders may be grouped with other responders
// returning kAudioClusterNone indicates responder is not part of any group
- (NSInteger)audioCluster;

//// responders receive this message after a member of its cluster has been hit (including the hit responder)
//- (void)audioClusterMemberWasHit;

@end
