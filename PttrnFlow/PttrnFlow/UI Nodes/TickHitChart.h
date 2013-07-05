//
//  TickHitChart.h
//  PttrnFlow
//
//  Created by John Saba on 7/5/13.
//
//

#import "cocos2d.h"

typedef enum
{
    kHitCellDefault = 0,
    kHitCellSuccess,
    kHitCellFailure,
} kHitCell;

@interface TickHitChart : CCNode

- (id)initWithNumberOfTicks:(int)numberOfTicks distanceInterval:(CGFloat)distanceInterval;

@end
