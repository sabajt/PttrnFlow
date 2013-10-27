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
static CGFloat const kHitChartHeight = 24;


@interface TickHitChart ()

@property (strong, nonatomic) NSMutableArray *hitCells;

@end


@implementation TickHitChart

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName steps:(int)steps unitSize:(CGSize)unitSize
{
    self = [super initWithSpriteFrameName:spriteFrameName];
    if (self) {
        if (steps < 1) {
            NSLog(@"warning: steps for TickHitChart should be > 1");
        }
        
        self.contentSize = CGSizeMake(unitSize.width * steps, unitSize.height);
        self.hitCells = [NSMutableArray array];

        for (int i = 0; i < steps; i++) {
            CCSprite *spr = [CCSprite spriteWithSpriteFrameName:@"chartbox_off.png"];
            spr.position = ccp((i * unitSize.width + (unitSize.width / 2)), unitSize.height / 2);
            self.hitCells[i] = spr;
            [self addChild:spr];
        }
    }
    return self;
}

- (void)handleTickHit:(NSNotification *)notification
{
    NSMutableArray *hits = notification.userInfo[kKeyHits];
    int index = hits.count - 1;
    NSNumber *hitSuccess = hits[index];
    
    kHitStatus status;
    if ([hitSuccess boolValue]) {
        status = kHitStatusSuccess;
    }
    else {
        status = kHitStatusFailure;
    }
    
    [self updateIndex:index state:status];
}

- (void)resetCells
{
    for (int i = 0; i < self.hitCells.count; i++) {
        [self updateIndex:i state:kHitStatusDefault];
    }
}

- (void)updateIndex:(int)index state:(kHitStatus)state
{
    NSLog(@"update index %i with status %i", index, state);
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
