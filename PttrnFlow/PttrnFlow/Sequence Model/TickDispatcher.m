//
//  TickDispatcher.m
//  SequencerGame
//
//  Created by John Saba on 4/30/13.
//
//

#import "TickDispatcher.h"
#import "GameConstants.h"
#import "Tone.h"
#import "Arrow.h"
#import "SGTiledUtils.h"
#import "CCTMXTiledMap+Utils.h"
#import "TickChannel.h"
#import "NSArray+CompareStrings.h"

NSInteger const kBPM = 120;

NSString *const kNotificationAdvancedSequence = @"advanceSequence";
NSString *const kNotificationTickHit = @"tickHit";

NSString *const kKeySequenceIndex = @"sequenceIndex";
NSString *const kKeyHits = @"hits";

NSString *const kExitEvent = @"exit";

CGFloat const kTickInterval = 0.5;


@interface TickDispatcher ()

@property (strong, nonatomic) NSMutableArray *responders;
@property (strong, nonatomic) NSMutableArray *lastTickedResponders;
@property (assign) int sequenceIndex;
@property (assign) GridCoord gridSize;
@property (strong, nonatomic) NSMutableArray *eventSequence;
@property (strong, nonatomic) NSMutableSet *channels;
@property (strong, nonatomic) NSMutableArray *hits;
@property (assign) int tickCounter;

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
        self.channels = [NSMutableSet set];
        for (NSMutableDictionary *entry in entries) {
            NSString *channel = [entry objectForKey:kTLDPropertyChannel];
            GridCoord cell = [tiledMap gridCoordForObject:entry];
            kDirection direction = [SGTiledUtils directionNamed:[entry objectForKey:kTLDPropertyDirection]];
            TickChannel *tickChannel = [[TickChannel alloc] initWithChannel:[channel intValue] startingDirection:direction startingCell:cell];
            [self.channels addObject:tickChannel];
        }
        
        self.sequenceIndex = 0;
        self.responders = [NSMutableArray array];
        self.gridSize = [GridUtils gridCoordFromSize:tiledMap.mapSize];
        self.lastTickedResponders = [NSMutableArray array];
        self.synth = synth;
    }
    return self;
}

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

// public method to kick off the sequence
- (void)start
{
    self.tickCounter = 0;
    if (self.hits == nil) {
        self.hits = [NSMutableArray array];
    }
    else {
        [self.hits removeAllObjects];
    }
    
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

// play the sound from the stored sequence an index
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

// moves the ticker along the grid
- (void)tick:(ccTime)dt
{
    // handle 'after tick'
    for (id<TickResponder> responder in self.lastTickedResponders) {
        [responder afterTick:kBPM];
    }
    [self.lastTickedResponders removeAllObjects];
    
    // stop and check for winning conditions if we have reached the tick limit
    if (self.tickCounter >= self.eventSequence.count) {
        [self stop];
        if ([self didWin]) {
            [self.delegate win];
        }
        return;
    }
    
    NSMutableArray *combinedEvents = [NSMutableArray array];
    for (TickChannel *tickChannel in self.channels) {
        
        // skip if tick channel has stopped
        if (tickChannel.hasStopped) {
            continue;
        }
        
        // tick and collect events
        NSMutableArray *events = [NSMutableArray array];
        for (id<TickResponder> responder in self.responders) {
            if ([GridUtils isCell:[responder responderCell] equalToCell:tickChannel.currentCell]) {
                [events addObject:[responder tick:kBPM]];
                [self.lastTickedResponders addObject:responder];
            }
        }
        
        // the first time we have no event, this means we hit no blocks -- this is an 'exit' event
        if (events.count == 0) {
            [events addObject:kExitEvent];
            [self.delegate tickExit:tickChannel.currentCell];
        }
        
        [tickChannel update:events];
        [combinedEvents addObjectsFromArray:events];
    }
    
    // stop if we have no combined events
    if (combinedEvents.count == 0) {
        [self stop];
        return;
    }
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTickHit object:nil userInfo:@{kKeyHits : self.hits}];
    
    // synth talks to our PD patch
    // TODO: this should probably be filtered events, unless synth has some reason to care about non-synth events?
    [self.synth receiveEvents:combinedEvents];
    
    // advance cells, tick counter
    for (TickChannel *tickChannel in self.channels) {
        tickChannel.currentCell = [tickChannel nextCell];
    }
    self.tickCounter++;
}

- (BOOL)testHit:(NSMutableArray *)hit tick:(int)tick
{
    if (tick >= self.eventSequence.count) {
        return NO;
    }
    NSArray *events = [self.eventSequence objectAtIndex:tick];
    return [events containsSameStrings:hit];
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

#pragma mark - 

+ (BOOL)isArrowEvent:(NSString *)event
{
    if ([event isEqualToString:@"up"] || [event isEqualToString:@"down"] || [event isEqualToString:@"right"] || [event isEqualToString:@"left"] || [event isEqualToString:@"n"])
    {
        return YES;
    }
    return NO;
}

@end
