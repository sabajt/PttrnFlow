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

@interface AudioTouchDispatcher ()

@property (strong, nonatomic) NSMutableArray *responders;
@property (assign) CFMutableDictionaryRef currentChannelsByTouches;


@end

@implementation AudioTouchDispatcher

- (id)init
{
    self = [super init];
    if (self) {
        _responders = [NSMutableArray array];
        _currentChannelsByTouches = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

- (void)addResponder:(id<TickResponder>)responder
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
    for (id<TickResponder> responder in self.responders) {
        if ([GridUtils isCell:[responder responderCell] equalToCell:cell]) {
            NSArray *responderFragmnets = [responder tick:kBPM];
            [fragments addObjectsFromArray:responderFragmnets];
        }
    }
    
    // crunch fragments into events and send to pd
    NSArray *events = [TickEvent eventsFromFragments:fragments channel:channel lastLinkedEvents:nil];
    [MainSynth receiveEvents:events];
    
    // send events to pd
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchBegan:touch withEvent:event];
    
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    
    // track touch so we know which fragments / cell to associate
    CFIndex count = CFDictionaryGetCount(self.currentChannelsByTouches);
    NSString *channel = [NSString stringWithFormat:@"%ld", count];
    NSDictionary *touchInfo = @{@"channel" : channel, @"x" : @(cell.x), @"y" : @(cell.y)};
    NSMutableDictionary *mutableTouchInfo = [NSMutableDictionary dictionaryWithDictionary:touchInfo];
    CFDictionaryAddValue(self.currentChannelsByTouches, (__bridge void *)(touch), (__bridge void *)(mutableTouchInfo));
    
    [self processFragmentsForCell:cell channel:channel];
    
    NSLog(@"<)))))))) audio touch dispatcher TOUCH BEGAN : channel [ %@ ] : cell [ %i , %i ]", channel, cell.x, cell.y);
    NSLog(@"\n\n");
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchMoved:touch withEvent:event];
    
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    
    // get channel and last touched cell of this specific touch
    NSMutableDictionary *touchInfo = CFDictionaryGetValue(self.currentChannelsByTouches, (__bridge void *)touch);
    NSString *channel = [touchInfo objectForKey:@"channel"];
    NSNumber *x = [touchInfo objectForKey:@"x"];
    NSNumber *y = [touchInfo objectForKey:@"y"];
    GridCoord lastCell = GridCoordMake([x intValue], [y intValue]);
    
    // if touch moved to a new cell, update info
    if (![GridUtils isCell:cell equalToCell:lastCell]) {
        [touchInfo setObject:@(cell.x) forKey:@"x"];
        [touchInfo setObject:@(cell.y) forKey:@"y"];
        CFDictionaryReplaceValue(self.currentChannelsByTouches, (__bridge void *)(touch), (__bridge void *)(touchInfo));
        
        [self processFragmentsForCell:cell channel:channel];
        
        NSLog(@"<)))))))) audio touch dispatcher TOUCH MOVED : channel [ %@ ] : cell [ %i , %i ]", channel, cell.x, cell.y);
        NSLog(@"\n\n");
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    
    CFDictionaryRemoveValue(self.currentChannelsByTouches, (__bridge void *)touch);
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    
    CFDictionaryRemoveValue(self.currentChannelsByTouches, (__bridge void *)touch);
}


@end
