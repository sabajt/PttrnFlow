//
//  TickDispatcher.m
//  SequencerGame
//
//  Created by John Saba on 4/30/13.
//
//

#import "TickDispatcher.h"
#import "GameConstants.h"
#import "Arrow.h"
#import "SGTiledUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "TickChannel.h"
#import "NSArray+CompareStrings.h"
#import "TickEvent.h"
#import "ExitEvent.h"


NSInteger const kBPM = 120;
NSString *const kNotificationAdvancedSequence = @"advanceSequence";
NSString *const kNotificationTickHit = @"tickHit";
NSString *const kKeySequenceIndex = @"sequenceIndex";
NSString *const kKeyHits = @"hits";

CGFloat const kTickInterval = 0.5;

@interface TickDispatcher ()

@property (strong, nonatomic) NSMutableArray *responders;
@property (strong, nonatomic) NSMutableArray *lastTickedResponders;
@property (assign) int sequenceIndex;
@property (assign) GridCoord gridSize;
@property (strong, nonatomic) NSMutableArray *eventSequence;
@property (strong, nonatomic) NSSet *channels;
@property (strong, nonatomic) NSMutableSet *dynamicChannels;

@property (strong, nonatomic) NSMutableArray *hits;
@property (assign) int currentQuarterTick;

// for each channel, track most recent synth related events so we can compare with solution
@property (strong, nonatomic) NSMutableDictionary *lastLinkedEvents;

@end


@implementation TickDispatcher

- (id)initWithSequence:(NSMutableDictionary *)sequence tiledMap:(CCTMXTiledMap *)tiledMap synth:(id<SoundEventReceiver>)synth
{
    self = [super init];
    if (self) {

        NSString *rawEventSeq = [sequence objectForKey:kTLDPropertyEvents];
        NSArray *groupByTick = [rawEventSeq componentsSeparatedByString:@";"];
        self.sequenceLength = groupByTick.count;
        self.eventSequence = [self constructEventSequence:groupByTick];
        
        NSMutableArray *entries = [tiledMap objectsWithName:kTLDObjectEntry groupName:kTLDGroupTickResponders];
        NSMutableSet *channels = [NSMutableSet set];
        for (NSMutableDictionary *entry in entries) {
            NSString *channel = [entry objectForKey:kTLDPropertyChannel];
            GridCoord cell = [tiledMap gridCoordForObject:entry];
            kDirection direction = [SGTiledUtils directionNamed:[entry objectForKey:kTLDPropertyDirection]];
            TickChannel *tickChannel = [[TickChannel alloc] initWithChannel:[channel intValue] startingDirection:direction startingCell:cell];
            [channels addObject:tickChannel];
        }
        self.channels = [NSSet setWithSet:channels];
        
        self.sequenceIndex = 0;
        self.responders = [NSMutableArray array];
        self.gridSize = [GridUtils gridCoordFromSize:tiledMap.mapSize];
        self.lastTickedResponders = [NSMutableArray array];
        self.hits = [NSMutableArray array];
        self.synth = synth;
        
        self.lastLinkedEvents = [NSMutableDictionary dictionary];
    }
    //
    return self;
}

#pragma mark - setup

// TODO: change to use TickEvent
- (NSMutableArray *)constructEventSequence:(NSArray *)groupedByTick
{
    // example: [[@"48-s", @"d1"], [@"50-2", @"d2"], [@"48-t", @"d1-x1"]]
    
    NSMutableArray *eventSequence = [NSMutableArray array];
    for (NSString *event in groupedByTick) {
        NSArray *eventChain = [event componentsSeparatedByString:@","];
        [eventSequence addObject:eventChain];
    }
    return eventSequence;
}

- (void)addDynamicChannel:(int)channel startingCell:(GridCoord)cell startingDirection:(kDirection)direction
{
    TickChannel *ch = [[TickChannel alloc] initWithChannel:channel startingDirection:direction startingCell:cell];
    [self.dynamicChannels addObject:ch];
}


- (void)handleRemoveResponder:(NSNotification *)notification
{
    id<TickResponder> responder =  notification.object;
    if ([self.responders containsObject:responder]) {
        [self.responders removeObject:responder];
    }
}

- (void)registerTickResponder:(id<TickResponder>)responder
{
    NSAssert([responder conformsToProtocol:@protocol(TickResponder)], @"registered tick responders much conform to TickResponder protocol");
    [self.responders addObject:responder];
}

#pragma mark - control

// public method to kick off the sequence
- (void)start
{
    self.currentQuarterTick = 0;

    [self.dynamicChannels removeAllObjects];
    [self.hits removeAllObjects];
    
    for (TickChannel *channel in self.channels) {
        [channel reset];
    }
    
    [self schedule:@selector(tick:) interval:kTickInterval];
}

// public method to stop the sequence
- (void)stop
{
    [self unschedule:@selector(tick:)];
}

// TODO: change to use TickEvent
// play the sound from the stored sequence at an index
- (void)play:(int)index
{
    if ((index >= self.sequenceLength) || (index < 0)) {
        NSLog(@"warning: index out of TickDispatcher range");
        return;
    }
    
    NSArray *events = [self.eventSequence objectAtIndex:index];
    [self.synth receiveEvents:events];
}

// schedule the stored sequence we want to solve for from the top
- (void)scheduleSequence
{
    self.sequenceIndex = 0;
    [self schedule:@selector(advanceSequence) interval:kTickInterval];
}

// play an item from the stored sequence and progress
- (void)advanceSequence
{
    if (self.sequenceIndex >= self.sequenceLength) {
        NSLog(@"finished ticking");
        [self unschedule:@selector(advanceSequence)];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAdvancedSequence object:nil userInfo:@{kKeySequenceIndex:@(self.sequenceIndex)}];
    [self play:self.sequenceIndex];
    self.sequenceIndex++;
}

// moves all tickers along the grid
- (void)tick:(ccTime)dt
{
    // handle 'after tick'
    for (id<TickResponder> responder in self.lastTickedResponders) {
        [responder afterTick:kBPM];
    }
    [self.lastTickedResponders removeAllObjects];
    
    // stop and check for winning conditions if we have reached the tick limit
    if (self.currentQuarterTick >= self.eventSequence.count) {
        [self stop];
        if ([self didWin]) {
            [self.delegate win];
        }
        return;
    }
    
    // collect events for tick on each channel
    NSMutableArray *combinedEvents = [NSMutableArray array];
    NSSet *channels = [self.channels setByAddingObjectsFromSet:self.dynamicChannels];
    for (TickChannel *tickChannel in channels) {
        
        // skip if tick channel has stopped
        if (tickChannel.hasStopped) {
            continue;
        }
        
        // tick and collect event fragments for all responders at current cell
        NSMutableArray *fragments = [NSMutableArray array];
        for (id<TickResponder> responder in self.responders) {
            if ([GridUtils isCell:[responder responderCell] equalToCell:tickChannel.currentCell]) {
                [fragments addObject:[responder tick:kBPM]];
                [self.lastTickedResponders addObject:responder];
            }
        }
        
        // construct events that synths can understand from fragments
        // multiple fragments on a cell may create one or many events...
        NSArray *events = [TickEvent eventsFromFragments:fragments channel:tickChannel.channel lastLinkedEvents:self.lastLinkedEvents];
        
        // refresh last linked events for each channel.
        // current supports only one linked event at a time per channel
        for (TickEvent *event in events) {
            if (event.lastLinkedEvent != nil) {
                if ([self.lastLinkedEvents objectForKey:@(tickChannel.channel)] == nil) {
                    [self.lastLinkedEvents setObject:event forKey:@(tickChannel.channel)];
                    break;
                }
            }
        }
        
        // if we have no event, we've hit no blocks -- this is an exit event
        if (events.count == 0) {
            events = @[[[ExitEvent alloc] initWithChannel:tickChannel.channel lastLinkedEvent:nil fragments:nil]];
            [self.delegate tickExit:tickChannel.currentCell];
        }
        
        // tick events may affect spacial / game logic of tick channels
        [tickChannel update:events];
        
        // tick events collected in combined events will also be sent to pd synth to create sound
        [combinedEvents addObjectsFromArray:events];
    }
    
    // stop if we have no events from any channel
    if (combinedEvents.count == 0) {
        [self stop];
        return;
    }
    
#pragma mark - LEFT OFF HERE
    // TODO: event comparison function just finished -- work on method to compare combined events and solution events
    
    // check for correct hits
    NSMutableArray *filtered = [MainSynth filterSoundEvents:combinedEvents];
    if ([self testHit:filtered tick:self.tickCounter]) {
        NSLog(@"HIT");
        [self.hits addObject:@(YES)];
        
    }
    else {
        NSLog(@"MISS");
        [self.hits addObject:@(NO)];
    }
    
    [self.hits addObject:@(NO)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTickHit object:nil userInfo:@{kKeyHits : self.hits}];
    
    // synth talks to our PD patch
    // TODO: this should probably be filtered events, unless synth has some reason to care about non-synth events?
    [self.synth receiveEvents:combinedEvents];
    
    // advance cells, tick counter
    for (TickChannel *tickChannel in self.channels) {
        tickChannel.currentCell = [tickChannel nextCell];
    }
    self.currentQuarterTick++;
}

- (BOOL)testHit:(NSMutableArray *)hit tick:(int)tick
{
    if (tick >= self.eventSequence.count) {
        return NO;
    }
    NSArray *events = [self.eventSequence objectAtIndex:tick];
    return [events containsSameStrings:hit];
}

// did we hit correct patterns after ticking thru sequence?
- (BOOL)didWin
{
    for (NSNumber *hit in self.hits) {
        if (![hit boolValue]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - public queries

- (NSArray *)tickRespondersAtCell:(GridCoord)cell
{
    NSMutableArray *results = [NSMutableArray array];
    for (id<TickResponder> responder in self.responders) {
        if ([GridUtils isCell:cell equalToCell:[responder responderCell]]) {
            [results addObject:responder];
        }
    }
    return [NSArray arrayWithArray:results];
}

- (NSArray *)tickRespondersAtCell:(GridCoord)cell class:(Class)class
{
    NSMutableArray *results= [NSMutableArray array];
    for (id<TickResponder> responder in self.responders) {
        if ([GridUtils isCell:cell equalToCell:[responder responderCell]] && [responder isKindOfClass:class]) {
            [results addObject:responder];
        }
    }
    return [NSArray arrayWithArray:results];
}

- (BOOL)isAnyTickResponderAtCell:(GridCoord)cell
{
    for (id<TickResponder> responder in self.responders) {
        if ([GridUtils isCell:cell equalToCell:[responder responderCell]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - scene management

- (void)onEnter
{
    [super onEnter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoveResponder:) name:kNotificationRemoveTickReponder object:nil];
}

- (void)onExit
{
    [super onExit];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TickerControlDelegate

- (void)tickerMovedToIndex:(int)index
{
    [self play:index];
}

@end
