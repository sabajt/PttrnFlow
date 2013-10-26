//
//  TickerControl.h
//  PttrnFlow
//
//  Created by John Saba on 10/26/13.
//
//

#import "TouchSprite.h"
#import "PanSprite.h"

@protocol TickerControlDelegate <NSObject>

- (void)tickerMovedToIndex:(int)index;
- (void)tickerControlTouchUp;

@end

@interface TickerControl : TouchSprite <ScrollSpriteDelegate>

@property (weak, nonatomic) id<TickerControlDelegate> tickerControlDelegate;
@property (assign) int steps;
@property (assign) int currentIndex;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName steps:(int)steps unitSize:(CGSize)unitSize;

@end
