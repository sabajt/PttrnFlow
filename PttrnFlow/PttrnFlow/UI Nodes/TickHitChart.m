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
#import "TickDispatcher.h"

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
            CCSprite *hitCell = [self hitCell:kHitStatusDefault];
            hitCell.position = ccp((i * distanceInterval) + distanceInterval / 2, self.contentSize.height / 2);
            [self.hitCells addObject:hitCell];
            [self addChild:hitCell];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTickHit:) name:kNotificationTickHit object:nil];
    }
    return self;
}

- (CCSprite *)hitCell:(kHitStatus)status
{
    ccColor3B color;
    if (status == kHitStatusDefault) {
        color = [ColorUtils hitDefault];
    } else if (status == kHitStatusSuccess) {
        color = [ColorUtils hitSuccess];
    } else if (status == kHitStatusFailure) {
        color = [ColorUtils hitFailure];
    }
    return [CCSprite rectSpriteWithSize:CGSizeMake(self.distanceInterval, self.contentSize.height) edgeLength:kHitCellEdge edgeColor:[ColorUtils hitCellEdge] centerColor:color];
}

- (void)update:(int)index status:(kHitStatus)status
{
    CCSprite *hitCell = [self hitCell:status];
    CCSprite *oldCell = self.hitCells[index];
    hitCell.position = oldCell.position;
    [self addChild:hitCell];
    [oldCell removeFromParentAndCleanup:YES];
    [self.hitCells replaceObjectAtIndex:index withObject:hitCell];
}

- (void)handleTickHit:(NSNotification *)notification
{
    NSMutableArray *hits = notification.userInfo[kKeyHits];
    int tickIndex = hits.count - 1;
    NSNumber *hitSuccess = hits[tickIndex];
    kHitStatus status;
    if ([hitSuccess boolValue]) {
        status = kHitStatusSuccess;
    }
    else {
        status = kHitStatusFailure;
    }
    [self update:tickIndex status:status];
}

#pragma mark - CCNode SceneManagement

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

@end
