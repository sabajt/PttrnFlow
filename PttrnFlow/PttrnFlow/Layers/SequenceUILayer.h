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

@interface SequenceUILayer : CCLayer

- (id)initWithPuzzle:(NSUInteger)puzzle tickDispatcher:(TickDispatcher *)tickDispatcher dragItemDelegate:(id<DragItemDelegate>)dragItemDelegate;

@end
