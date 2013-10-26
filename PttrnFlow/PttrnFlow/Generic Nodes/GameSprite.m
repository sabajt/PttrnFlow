//
//  GameSprite.m
//  PttrnFlow
//
//  Created by John Saba on 9/14/13.
//
//

#import "GameSprite.h"

@implementation GameSprite

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName cell:(GridCoord)cell
{
    self = [self initWithSpriteFrameName:spriteFrameName];
    if (self) {
        _cell = cell;
        _cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

#pragma mark CCNode SceneManagement

- (void)onEnter
{
    [super onEnter];
    
    // modified version of CCLayerPanZoom sends this notification when we start panning,
    // drag distance buffer specified by a layer's maxTouchDistanceToClick property
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartPan) name:kNotificationStartPan object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

#pragma mark - Handle panning

// pan notification
- (void)handleStartPan
{
    [self cancelTouchForPan];
}

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan
{
    if (self.longPressDelay > 0) {
        [self unschedule:@selector(longPress:)];
    }
}

@end

