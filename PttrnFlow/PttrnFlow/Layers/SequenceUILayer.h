//
//  SequenceUILayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"
#import "DragItemDelegate.h"

@class TickDispatcher;

FOUNDATION_EXPORT CGFloat const kUIButtonUnitSize;
FOUNDATION_EXPORT CGFloat const kUITimelineStepWidth;
FOUNDATION_EXPORT CGFloat const kUILineWidth;

@interface SequenceUILayer : CCLayer

- (id)initWithPuzzle:(NSUInteger)puzzle tickDispatcher:(TickDispatcher *)tickDispatcher dragItemDelegate:(id<DragItemDelegate>)dragItemDelegate;

@end
