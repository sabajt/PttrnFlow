//
//  AudioTouchDispatcher.m
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "PFLAudioTouchController.h"
#import "PFLEvent.h"
#import "PFLPatchController.h"
#import "PFLCoord.h"
#import "NSObject+AudioResponderUtils.h"
#import "PFLAudioPadSprite.h"
#import "CCNode+Grid.h"

NSString *const kPFLAudioTouchDispatcherCoordKey = @"coord";
NSString *const kPFLAudioTouchDispatcherHitNotification = @"kPFLAudioTouchDispatcherHitNotification";

@interface PFLAudioTouchController ()

@property (strong, nonatomic) NSMutableArray *responders;
@property (assign) CFMutableDictionaryRef trackingTouches;

@end

@implementation PFLAudioTouchController

- (id)initWithBeatDuration:(CGFloat)duration
{
    self = [super init];
    if (self) {
        _responders = [NSMutableArray array];
        _trackingTouches = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        self.beatDuration = duration;
    }
    return self;
}

- (void)addResponder:(id<PFLAudioResponder>)responder
{
    [self.responders addObject:responder];
}

- (void)clearResponders
{
    [self.responders removeAllObjects];
}

- (void)hitCell:(PFLCoord *)coord channel:(NSString *)channel
{
    // collect events from all hit cells
    NSArray *events = [self hitResponders:self.responders atCoord:coord];
    
    // block scrolling the puzzle if there are any events
    self.allowScrolling = (events.count == 0);
    
    // send events to pd
    [[PFLPatchController sharedMainSynth] receiveEvents:events];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPFLAudioTouchDispatcherHitNotification object:nil userInfo:@{kPFLAudioTouchDispatcherCoordKey : coord}];
}

// TODO: currently not being used
- (void)releaseCell:(PFLCoord *)cell channel:(NSString *)channel
{
    for (id<PFLAudioResponder> responder in self.responders) {
        if (([cell isEqualToCoord:[responder audioCell]]) &&
            [responder respondsToSelector:@selector(audioRelease:)])
        {
            [responder audioRelease:1];
        }
    }
}

- (void)changeToCell:(PFLCoord *)toCell fromCell:(PFLCoord *)fromCell channel:(NSString *)channel
{
    // don't do anything if responders at to cell
    NSArray *toCellResponders = [self responders:self.responders atCoord:toCell];
    if (toCellResponders.count > 0) {
        return;
    }
    
    // move any responders to available cell if audio pad is not static
    PFLAudioPadSprite *pad;
    NSArray *fromCellResponders = [self responders:self.responders atCoord:fromCell];
    if (fromCellResponders.count > 0) {
        NSInteger found = [fromCellResponders indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [obj isKindOfClass:[PFLAudioPadSprite class]];
        }];
        if (found != NSNotFound) {
            pad = fromCellResponders[found];
        }
    }
    if (pad && !pad.isStatic && [toCell isCoordInGroup:self.areaCells]) {
        for (CCNode<PFLAudioResponder> *node in fromCellResponders) {
            node.position = [toCell relativeMidpoint];
            node.cell = toCell;
        }
    }
}

#pragma mark CCNode SceneManagement

- (void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

- (void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    PFLCoord *cell = [PFLCoord coordForRelativePosition:touchPosition];
    
    // track touch so we know which events / cell to associate
    CFIndex count = CFDictionaryGetCount(self.trackingTouches);
    NSString *channel = [NSString stringWithFormat:@"%ld", count];
    NSDictionary *touchInfo = @{@"channel" : channel, @"x" : @(cell.x), @"y" : @(cell.y)};
    NSMutableDictionary *mutableTouchInfo = [NSMutableDictionary dictionaryWithDictionary:touchInfo];
    CFDictionaryAddValue(self.trackingTouches, (__bridge void *)(touch), (__bridge void *)(mutableTouchInfo));
    
    [self hitCell:cell channel:channel];
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    PFLCoord *cell = [PFLCoord coordForRelativePosition:touchPosition];
    
    // get channel and last touched cell of this specific touch
    NSMutableDictionary *touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
    NSString *channel = [touchInfo objectForKey:@"channel"];
    NSNumber *x = touchInfo[@"x"];
    NSNumber *y = [touchInfo objectForKey:@"y"];
    PFLCoord *lastCell = [PFLCoord coordWithX:[x integerValue] Y:[y integerValue]];
    
    // if touch moved to a new cell, update info
    if (![cell isEqualToCoord:lastCell]) {
        [touchInfo setObject:@(cell.x) forKey:@"x"];
        [touchInfo setObject:@(cell.y) forKey:@"y"];
        CFDictionaryReplaceValue(self.trackingTouches, (__bridge void *)(touch), (__bridge void *)(touchInfo));
        
        // process cell change
        [self changeToCell:cell fromCell:lastCell channel:channel];
        
        // TODO: hit / release will only be needed when working with PD synths later
//        [self releaseCell:lastCell channel:channel];
//        [self hitCell:cell channel:channel];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get channel
    NSMutableDictionary *touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
    NSString *channel = [touchInfo objectForKey:@"channel"];
    PFLEvent *audioStopEvent = [PFLEvent audioStopEventWithAudioID:nil];
    [[PFLPatchController sharedMainSynth] receiveEvents:@[audioStopEvent]];
    
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    PFLCoord *cell = [PFLCoord coordForRelativePosition:touchPosition];
    [self releaseCell:cell channel:channel];
    
    CFDictionaryRemoveValue(self.trackingTouches, (__bridge void *)touch);
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get channel
    NSMutableDictionary *touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
    NSString *channel = [touchInfo objectForKey:@"channel"];
    PFLEvent *audioStopEvent = [PFLEvent audioStopEventWithAudioID:nil];
    [[PFLPatchController sharedMainSynth] receiveEvents:@[audioStopEvent]];
    
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    PFLCoord *cell = [PFLCoord coordForRelativePosition:touchPosition];
    [self releaseCell:cell channel:channel];
    
    CFDictionaryRemoveValue(self.trackingTouches, (__bridge void *)touch);
}

#pragma mark - ScrollLayerDelegate

- (BOOL)shouldScroll
{
    return self.allowScrolling;
}

@end
