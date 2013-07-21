//
//  SynthCellNode.m
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import "SynthCellNode.h"

@implementation SynthCellNode

- (id)initWithSynth:(id<SoundEventReceiver>)synth
{
    self = [super init];
    if (self) {
        self.synth = synth;
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    
    // modified version of CCLayerPanZoom sends this notification when we start panning -- drag distance buffer specified by a layer's maxTouchDistanceToClick property
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStartPan) name:kNotificationStartPan object:nil];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

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
