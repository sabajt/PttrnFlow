//
//  TickDispatcher.h
//  SequencerGame
//
//  Created by John Saba on 4/30/13.
//
//

#import <Foundation/Foundation.h>
#import "MainSynth.h"
#import "TickerControl.h"
#import "AudioResponder.h"

FOUNDATION_EXPORT NSInteger const kBPM;
FOUNDATION_EXPORT NSString *const kNotificationAdvancedSequence;
FOUNDATION_EXPORT NSString *const kNotificationTickHit;
FOUNDATION_EXPORT NSString *const kKeySequenceIndex;
FOUNDATION_EXPORT NSString *const kKeyHits;
FOUNDATION_EXPORT NSString *const kExitEvent;
FOUNDATION_EXPORT CGFloat const kTickInterval;

@protocol TickDispatcherDelegate <NSObject>

- (void)tickExit:(Coord *)cell;
- (void)win;

@end


@interface TickDispatcher : CCNode <TickerControlDelegate>

@property (weak, nonatomic) id<TickDispatcherDelegate> delegate;
@property (assign) int sequenceLength;

// setup
- (id)initWithSequence:(int)sequence;
- (void)registerAudioResponderCellNode:(id<AudioResponder>)responder;

// control
- (void)start;
- (void)stop;
- (void)play:(int)index;
- (void)scheduleSequence;

@end
