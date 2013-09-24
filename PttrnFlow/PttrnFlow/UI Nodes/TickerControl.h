//
//  TickerControl.h
//  PttrnFlow
//
//  Created by John Saba on 6/9/13.
//
//

#import "GameNode.h"

@protocol TickerControlDelegate <NSObject>

- (void)tickerMovedToIndex:(int)index;
- (void)tickerControlTouchUp;

@end

@interface TickerControl : GameNode;

// TODO: rename this to tickerControlDelegate
@property (weak, nonatomic) id<TickerControlDelegate> delegate;
@property (assign) int numberOfTicks;
@property (assign) int currentIndex;

- (id)initWithNumberOfTicks:(int)numberOfTicks padding:(CGFloat)padding batchNode:(CCSpriteBatchNode *)batchNode origin:(CGPoint)origin;

@end
