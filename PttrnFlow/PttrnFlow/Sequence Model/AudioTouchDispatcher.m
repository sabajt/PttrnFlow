//
//  AudioTouchDispatcher.m
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "AudioTouchDispatcher.h"
#import "TickEvent.h"
#import "MainSynth.h"
#import "GridUtils.h"
#import "TickDispatcher.h"
#import "AudioStopEvent.h"

@interface AudioTouchDispatcher ()

@property (strong, nonatomic) NSMutableArray *responders;
@property (assign) CFMutableDictionaryRef trackingTouches;

@end

@implementation AudioTouchDispatcher

+ (AudioTouchDispatcher *)sharedAudioTouchDispatcher
{
    static AudioTouchDispatcher *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioTouchDispatcher alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _responders = [NSMutableArray array];
        _trackingTouches = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

- (void)addResponder:(id<AudioResponder>)responder
{
    [self.responders addObject:responder];
}

- (void)clearResponders
{
    self.responders = nil;
}

- (void)processFragmentsForCell:(GridCoord)cell channel:(NSString *)channel
{
    // collect fragments for the responders at the cell we touched
    NSMutableArray *fragments = [NSMutableArray array];
    for (id<AudioResponder> responder in self.responders) {
        if ([GridUtils isCell:[responder responderCell] equalToCell:cell]) {
            NSArray *responderFragmnets = [responder audioHit:kBPM];
            [fragments addObjectsFromArray:responderFragmnets];
        }
    }
    
    // crunch fragments into events and send to pd
    NSArray *events = [TickEvent eventsFromFragments:fragments channel:channel lastLinkedEvents:nil];
    
    // block scrolling the puzzle if there are any events
    self.allowScrolling = (events.count == 0);
    
    // send events to pd
    [[MainSynth sharedMainSynth] receiveEvents:events ignoreAudioPad:NO];
}

- (void)audioRelease:(GridCoord)cell channel:(NSString *)channel
{
    for (id<AudioResponder> responder in self.responders) {
        if ([GridUtils isCell:[responder responderCell] equalToCell:cell] &&
            [responder respondsToSelector:@selector(audioRelease:)])
        {
            [responder audioRelease:kBPM];
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
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    
    // track touch so we know which fragments / cell to associate
    CFIndex count = CFDictionaryGetCount(self.trackingTouches);
    NSString *channel = [NSString stringWithFormat:@"%ld", count];
    NSDictionary *touchInfo = @{@"channel" : channel, @"x" : @(cell.x), @"y" : @(cell.y)};
    NSMutableDictionary *mutableTouchInfo = [NSMutableDictionary dictionaryWithDictionary:touchInfo];
    CFDictionaryAddValue(self.trackingTouches, (__bridge void *)(touch), (__bridge void *)(mutableTouchInfo));
    
    [self processFragmentsForCell:cell channel:channel];
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    
    // get channel and last touched cell of this specific touch
    NSMutableDictionary *touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
    NSString *channel = [touchInfo objectForKey:@"channel"];
    NSNumber *x = touchInfo[@"x"];
    NSNumber *y = [touchInfo objectForKey:@"y"];
    GridCoord lastCell = GridCoordMake([x intValue], [y intValue]);
    
    // if touch moved to a new cell, update info
    if (![GridUtils isCell:cell equalToCell:lastCell]) {
        
        [touchInfo setObject:@(cell.x) forKey:@"x"];
        [touchInfo setObject:@(cell.y) forKey:@"y"];
        CFDictionaryReplaceValue(self.trackingTouches, (__bridge void *)(touch), (__bridge void *)(touchInfo));
        
        [self audioRelease:lastCell channel:channel];
                
        [self processFragmentsForCell:cell channel:channel];
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get channel
    NSMutableDictionary *touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
    NSString *channel = [touchInfo objectForKey:@"channel"];
    AudioStopEvent *audioStop = [[AudioStopEvent alloc] initWithChannel:channel isAudioEvent:YES];
    [[MainSynth sharedMainSynth] receiveEvents:@[audioStop] ignoreAudioPad:YES];
    
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    [self audioRelease:cell channel:channel];
    
    CFDictionaryRemoveValue(self.trackingTouches, (__bridge void *)touch);
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // get channel
    NSMutableDictionary *touchInfo = CFDictionaryGetValue(self.trackingTouches, (__bridge void *)touch);
    NSString *channel = [touchInfo objectForKey:@"channel"];
    AudioStopEvent *audioStop = [[AudioStopEvent alloc] initWithChannel:channel isAudioEvent:YES];
    [[MainSynth sharedMainSynth] receiveEvents:@[audioStop] ignoreAudioPad:YES];
    
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    [self audioRelease:cell channel:channel];
    
    CFDictionaryRemoveValue(self.trackingTouches, (__bridge void *)touch);
}

#pragma mark - PanLayerDelegate

- (BOOL)shouldPan
{
    return self.allowScrolling;
}

@end
