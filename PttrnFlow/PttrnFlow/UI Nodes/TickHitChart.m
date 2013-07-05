//
//  TickHitChart.m
//  PttrnFlow
//
//  Created by John Saba on 7/5/13.
//
//

#import "TickHitChart.h"
#import "ColorUtils.h"
#import "CCSprite+Utils.h"

static CGFloat const kHitCellEdge = 2;

@interface TickHitChart ()

@property (assign) CGFloat distanceInterval;
@property (strong, nonatomic) NSMutableArray *hitCells;

@end


@implementation TickHitChart

- (id)initWithNumberOfTicks:(int)numberOfTicks distanceInterval:(CGFloat)distanceInterval
{
    self = [super init];
    if (self) {
        if (numberOfTicks < 1) {
            NSLog(@"warning: number of ticks for TickerControl should be > 1");
        }
        
        self.distanceInterval = distanceInterval;
        
        static CGFloat const kHitChartHeight = 24;
        self.contentSize = CGSizeMake(numberOfTicks * distanceInterval, kHitChartHeight);
        
        self.hitCells = [NSMutableArray array];
        for (int i = 0; i < numberOfTicks; i++) {
            CCSprite *hitCell = [self hitCell:kHitCellDefault];            
            hitCell.position = ccp((i * distanceInterval) + distanceInterval / 2, self.contentSize.height / 2);
            [self.hitCells addObject:hitCell];
            [self addChild:hitCell];
        }
    }
    return self;
}

- (CCSprite *)hitCell:(kHitCell)status
{
    ccColor3B color;
    if (status == kHitCellDefault) {
        color = [ColorUtils hitDefault];
    }
    else if (status == kHitCellSuccess) {
        color = [ColorUtils hitSuccess];
    }
    else if (status == kHitCellFailure) {
        color = [ColorUtils hitFailure];
    }
    
    return [CCSprite rectSpriteWithSize:CGSizeMake(self.distanceInterval, self.contentSize.height) edgeLength:kHitCellEdge edgeColor:[ColorUtils hitCellEdge] centerColor:color];
}

@end
