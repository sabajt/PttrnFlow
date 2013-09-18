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

- (id)initWithNumberOfTicks:(int)numberOfTicks padding:(CGFloat)padding batchNode:(CCSpriteBatchNode *)batchNode origin:(CGPoint)origin
{
    self = [super initWithBatchNode:batchNode];
    if (self) {
        if (numberOfTicks < 1) {
            NSLog(@"warning: number of ticks for TickerControl should be > 1");
        }
        
        self.hitCells = [NSMutableArray array];
        for (int i = 0; i < numberOfTicks; i++) {
            NSArray *frameNames = @[@"tick_chart_cell_default.png", @"tick_chart_cell_hit.png", @"tick_chart_cell_miss.png"];
            
            CCSprite *spr = [CCSprite spriteWithSpriteFrameName:@"tick_chart_cell_default.png"];
            CGPoint relPoint = ccp(i * (spr.contentSize.width + padding), 0);
            CGPoint absPoint = ccp(relPoint.x + origin.x, relPoint.y + origin.y);
            SpritePicker *hitCell = [[SpritePicker alloc] initWithFrameNames:frameNames center:absPoint batchNode:batchNode];
            [self.hitCells addObject:hitCell];
        }
        
        SpritePicker *lastCell = [self.hitCells lastObject];
        self.contentSize = CGSizeMake(lastCell.position.x + lastCell.contentSize.width, lastCell.contentSize.height);
        
        for (SpritePicker *picker in self.hitCells) {
            NSLog(@"cell pos: %@", NSStringFromCGPoint(picker.position));
        }
    }
    return self;
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

- (void)onEnter
{
    [super onEnter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTickHit:) name:kNotificationTickHit object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super onExit];
}

@end
