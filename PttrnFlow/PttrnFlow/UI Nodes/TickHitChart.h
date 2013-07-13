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
    kHitStatusDefault = 0,
    kHitStatusSuccess,
    kHitStatusFailure,
} kHitStatus;

@interface TickHitChart : CCNode

- (id)initWithNumberOfTicks:(int)numberOfTicks distanceInterval:(CGFloat)distanceInterval;
- (void)resetCells;

@end
