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

@interface AudioTouchDispatcher ()

@property (strong, nonatomic) NSMutableDictionary *currentFragments;
@property (strong, nonatomic) NSMutableArray *responders;

@end

@implementation AudioTouchDispatcher

- (id)init
{
    self = [super init];
    if (self) {
        _currentFragments = [NSMutableDictionary dictionary];
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

- (void)addFragments:(NSArray *)fragments channel:(NSString *)channel
{
    NSMutableArray *storedFragments = [self.currentFragments objectForKey:channel];
    if (storedFragments == nil) {
        storedFragments = [NSMutableArray array];
    }
    [storedFragments addObjectsFromArray:fragments];
    [self.currentFragments setObject:storedFragments forKey:channel];
}

- (void)clearFragments
{
    self.currentFragments = nil;
}

- (void)sendAudio:(NSString *)channel
{
    NSArray *fragments = [self.currentFragments objectForKey:channel];
    NSArray *events = [TickEvent eventsFromFragments:self.currentFragments[channel] channel:channel lastLinkedEvents:nil];
    
    // send events to pd
    
    [self clearFragments];
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchBegan:touch withEvent:event];
    
    // get grid cell of touch
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    GridCoord cell = [GridUtils gridCoordForRelativePosition:touchPosition unitSize:kSizeGridUnit];
    NSLog(@"cell: %i, %i", cell.x, cell.y);
    
    // get the responders at the cell we touched
    
    // collect events
    
    // send to pd patch
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchMoved:touch withEvent:event];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
}


@end
