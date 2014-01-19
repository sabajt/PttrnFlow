//
//  SequenceUILayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"
#import "ToggleButton.h"

@protocol PuzzleControlsDelegate <NSObject>

- (void)startUserSequence;
- (void)stopUserSequence;
- (void)startSolutionSequence;
- (void)stopSolutionSequence;
- (void)playSolutionIndex:(NSInteger)index;

@end

FOUNDATION_EXPORT CGFloat const kUIButtonUnitSize;
FOUNDATION_EXPORT CGFloat const kUITimelineStepWidth;
FOUNDATION_EXPORT CGFloat const kUILineWidth;

@interface SequenceUILayer : CCLayer <ToggleButtonDelegate>

- (id)initWithPuzzle:(NSUInteger)puzzle delegate:(id<PuzzleControlsDelegate>)delegate;

@end
