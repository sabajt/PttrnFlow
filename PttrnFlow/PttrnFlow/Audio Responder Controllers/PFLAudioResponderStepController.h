//
//  PFLAudioResponderStepController.h
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "CCNode.h"
#import "PFLPuzzleControlsLayer.h"
#import "PFLAudioResponder.h"
#import "PFLEntrySprite.h"

@class PFLPuzzle;

FOUNDATION_EXPORT NSString *const kNotificationStepUserSequence;
FOUNDATION_EXPORT NSString *const kNotificationStepSolutionSequence;
FOUNDATION_EXPORT NSString *const kNotificationEndUserSequence;
FOUNDATION_EXPORT NSString *const kNotificationEndSolutionSequence;
FOUNDATION_EXPORT NSString *const kKeyIndex;
FOUNDATION_EXPORT NSString *const kKeyCoord;
FOUNDATION_EXPORT NSString *const kKeyCorrectHit;
FOUNDATION_EXPORT NSString *const kKeyEmpty;

@interface PFLAudioResponderStepController : CCNode <PFLPuzzleControlsDelegate>

@property (weak, nonatomic) PFLEntrySprite *entry;

- (id)initWithPuzzle:(PFLPuzzle *)puzzle;
- (void)addResponder:(id<PFLAudioResponder>)responder;
- (void)clearResponders;

@end
