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

@class PFLPuzzle;

FOUNDATION_EXPORT NSString *const kNotificationStepUserSequence;
FOUNDATION_EXPORT NSString *const kNotificationStepSolutionSequence;
FOUNDATION_EXPORT NSString *const kNotificationEndUserSequence;
FOUNDATION_EXPORT NSString *const kNotificationEndSolutionSequence;
FOUNDATION_EXPORT NSString *const kKeyIndex;
FOUNDATION_EXPORT NSString *const kKeyCoord;
FOUNDATION_EXPORT NSString *const kKeyCorrectHit;
FOUNDATION_EXPORT NSString *const kKeyEmpty;

@interface SequenceDispatcher : CCNode <SequenceControlDelegate>

@property (weak, nonatomic) Entry *entry;

- (id)initWithPuzzle:(PFLPuzzle *)puzzle;
- (void)addResponder:(id<AudioResponder>)responder;
- (void)clearResponders;

@end
