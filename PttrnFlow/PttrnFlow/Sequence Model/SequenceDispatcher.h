//
//  SequenceDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "CCNode.h"
#import "SequenceControlsLayer.h"
#import "AudioResponder.h"
#import "Entry.h"

FOUNDATION_EXPORT NSString *const kNotificationStepUserSequence;
FOUNDATION_EXPORT NSString *const kNotificationStepSolutionSequence;
FOUNDATION_EXPORT NSString *const kNotificationEndUserSequence;
FOUNDATION_EXPORT NSString *const kKeyIndex;

@protocol SequenceDispatcherDelegate <NSObject>

- (void)hitCoordWithNoEvents:(Coord *)coord;

@end

@interface SequenceDispatcher : CCNode <SequenceControlDelegate>

@property (weak, nonatomic) id<SequenceDispatcherDelegate> delegate;
@property (weak, nonatomic) Entry *entry;

- (id)initWithPuzzle:(NSInteger)puzzle;
- (void)addResponder:(id<AudioResponder>)responder;
- (void)clearResponders;

@end
