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
#import "SpritePicker.h"

static CGFloat const kHitCellEdge = 2;
static CGFloat const kHitChartHeight = 24;


@interface TickHitChart ()

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
        self.contentSize = CGSizeMake(numberOfTicks * distanceInterval, kHitChartHeight);
        
        self.hitCells = [NSMutableArray array];
        for (int i = 0; i < numberOfTicks; i++) {
            CCSprite *cellDefault = [self hitCell:kHitStatusDefault width:distanceInterval];
            CCSprite *cellSuccess = [self hitCell:kHitStatusSuccess width:distanceInterval];
            CCSprite *cellFailure = [self hitCell:kHitStatusFailure width:distanceInterval];
            
            SpritePicker *hitCell = [[SpritePicker alloc] initWithSprites:@[cellDefault, cellSuccess, cellFailure]];
            hitCell.contentSize = cellDefault.contentSize;
            hitCell.position = ccp(i * distanceInterval, 0);
            [hitCell pickSprite:kHitStatusDefault];
            
            [self.hitCells addObject:hitCell];
            [self addChild:hitCell];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTickHit:) name:kNotificationTickHit object:nil];
    }
    return self;
}

- (CCSprite *)hitCell:(kHitStatus)status width:(CGFloat)width
{
    ccColor3B color;
    if (status == kHitStatusDefault) {
        color = [ColorUtils hitDefault];
    } else if (status == kHitStatusSuccess) {
        color = [ColorUtils hitSuccess];
    } else if (status == kHitStatusFailure) {
        color = [ColorUtils hitFailure];
    }
    return [CCSprite rectSpriteWithSize:CGSizeMake(width, self.contentSize.height) edgeLength:kHitCellEdge edgeColor:[ColorUtils hitCellEdge] centerColor:color];
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
    
    SpritePicker *hitCell = self.hitCells[tickIndex];
    [hitCell pickSprite:status];
}

- (void)resetCells
{
    for (SpritePicker *cell in self.hitCells) {
        [cell pickSprite:kHitStatusDefault];
    }
}

#pragma mark - CCNode SceneManagement

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

@end
