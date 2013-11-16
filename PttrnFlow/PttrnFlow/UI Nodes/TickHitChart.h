//
//  TickHitChart.h
//  PttrnFlow
//
//  Created by John Saba on 7/5/13.
//
//

#import "cocos2d.h"
#import "TouchSprite.h"

typedef enum
{
    kHitStatusDefault = 0,
    kHitStatusSuccess,
    kHitStatusFailure,
} kHitStatus;

@interface TickHitChart : TouchSprite

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName steps:(int)steps unitSize:(CGSize)unitSize;
- (void)resetCells;

@end
