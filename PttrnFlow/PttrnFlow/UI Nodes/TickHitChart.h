//
//  TickHitChart.h
//  PttrnFlow
//
//  Created by John Saba on 7/5/13.
//
//

#import "GameNode.h"

typedef enum
{
    kHitStatusDefault = 0,
    kHitStatusSuccess,
    kHitStatusFailure,
} kHitStatus;

@interface TickHitChart : GameNode

- (id)initWithNumberOfTicks:(int)numberOfTicks padding:(CGFloat)padding batchNode:(CCSpriteBatchNode *)batchNode;
- (void)resetCells;

@end
