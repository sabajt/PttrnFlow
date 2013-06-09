//
//  TickerControl.h
//  PttrnFlow
//
//  Created by John Saba on 6/9/13.
//
//

#import "cocos2d.h"

@interface TickerControl : CCNode <CCTargetedTouchDelegate>

@property (weak, nonatomic) CCSprite *thumbSprite;
@property (assign) int numberOfTicks;

- (id)initWithNumberOfTicks:(int)numberOfTicks;

@end
