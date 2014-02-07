//
//  SequenceUILayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"
#import "ToggleButton.h"
#import "BasicButton.h"
#import "SolutionButton.h"

@protocol SequenceControlDelegate <NSObject>

- (void)startUserSequence;
- (void)stopUserSequence;
- (void)startSolutionSequence;
- (void)stopSolutionSequence;
- (void)playSolutionIndex:(NSInteger)index;

@end

FOUNDATION_EXPORT CGFloat const kUIButtonUnitSize;

@interface SequenceControlsLayer : CCLayer <ToggleButtonDelegate, BasicButtonDelegate, SolutionButtonDelegate>

- (id)initWithPuzzle:(NSUInteger)puzzle delegate:(id<SequenceControlDelegate>)delegate;

@end
