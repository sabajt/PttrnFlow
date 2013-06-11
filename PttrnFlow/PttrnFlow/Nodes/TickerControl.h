//
//  TickerControl.h
//  PttrnFlow
//
//  Created by John Saba on 6/9/13.
//
//

#import "cocos2d.h"

@protocol TickerControlDelegate <NSObject>

- (void)tickerMovedToIndex:(int)index;

@end

@interface TickerControl : CCNode <CCTargetedTouchDelegate>

@property (weak, nonatomic) id<TickerControlDelegate> delegate;
@property (weak, nonatomic) CCSprite *thumbSprite;
@property (assign) int numberOfTicks;
@property (assign) int currentIndex;

- (id)initWithNumberOfTicks:(int)numberOfTicks;

@end
