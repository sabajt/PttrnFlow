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
#import "SolutionSequence.h"


NSInteger const kBPM = 120;
NSString *const kNotificationAdvancedSequence = @"advanceSequence";
NSString *const kNotificationTickHit = @"tickHit";
NSString *const kKeySequenceIndex = @"sequenceIndex";
NSString *const kKeyHits = @"hits";
NSString *const kExitEvent = @"ExitEvent";

CGFloat const kTickInterval = 0.12;

@interface TickDispatcher ()

@property (strong, nonatomic) NSMutableArray *responders;
@property (strong, nonatomic) NSMutableArray *lastTickedResponders;
@property (strong, nonatomic) NSMutableArray *hits;
@property (strong, nonatomic) NSMutableSet *dynamicChannels;
@property (strong, nonatomic) NSSet *channels;
@property (strong, nonatomic) SolutionSequence *solutionSequence;

@property (assign) int sequenceIndex;
@property (assign) int currentTick;
@property (assign) GridCoord gridSize;


// for each channel, track most recent synth related events so we can compare with solution
@property (strong, nonatomic) NSMutableDictionary *lastLinkedEvents;

@end


@implementation TickDispatcher

- (id)initWithSequence:(int)sequence tiledMap:(CCTMXTiledMap *)tiledMap
{
    self = [super init];
    if (self) {
        
        // new event sequence
        self.solutionSequence = [[SolutionSequence alloc] initWithSolution:[NSString stringWithFormat:@"solution%i", sequence]];
        self.sequenceLength = self.solutionSequence.sequence.count;
        
        // create initial channels
        NSMutableArray *entries = [tiledMap objectsWithName:kTLDObjectEntry groupName:kTLDGroupTickResponders];
        NSMutableSet *channels = [NSMutableSet set];
        for (NSMutableDictionary *entry in entries) {
            NSString *channel = [entry objectForKey:kTLDPropertyChannel];
            GridCoord cell = [tiledMap gridCoordForObject:entry];
            kDirection direction = [SGTiledUtils directionNamed:[entry objectForKey:kTLDPropertyDirection]];
            TickChannel *tickChannel = [[TickChannel alloc] initWithChannel:channel startingDirection:direction startingCell:cell];
            [channels addObject:tickChannel];
        }
        self.channels = [NSSet setWithSet:channels];
        
        // other setup
        self.sequenceIndex = 0;
        self.responders = [NSMutableArray array];
        self.gridSize = [GridUtils gridCoordFromSize:tiledMap.mapSize];
        self.lastTickedResponders = [NSMutableArray array];
        self.hits = [NSMutableArray array];
        self.lastLinkedEvents = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - setup

- (void)addDynamicChannel:(NSString *)channel startingCell:(GridCoord)cell startingDirection:(kDirection)direction
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
    self.currentTick = 0;

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

// play the sound from the stored sequence at an index
- (void)play:(int)index
{
    if ((index >= self.solutionSequence.sequence.count) || (index < 0)) {
        NSLog(@"warning: index out of TickDispatcher range");
        return;
    }
    
    NSArray *events = [self.solutionSequence.sequence objectAtIndex:index];
    [MainSynth receiveEvents:events ignoreAudioPad:YES];
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
    if (self.currentTick >= self.solutionSequence.sequence.count) {
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
                NSArray *responderFragmnets = [responder tick:kBPM];
                [fragments addObjectsFromArray:responderFragmnets];
                [self.lastTickedResponders addObject:responder];
            }
        }
        
        // construct events that synths can understand from fragments
        // multiple fragments on a cell may create one or many events...
        NSArray *events = [TickEvent eventsFromFragments:fragments channel:tickChannel.channel lastLinkedEvents:self.lastLinkedEvents];
        
        // refresh last linked events for each channel.
        // current supports only one linked event at a time per channel
        for (TickEvent *event in events) {
            if (event.isLinkedEvent) {
                [self.lastLinkedEvents setObject:event forKey:tickChannel.channel];
                break;
            }
        }
        
        // if we have no event, we've hit no blocks -- this is an exit event
        if (events.count == 0) {
            events = @[[[ExitEvent alloc] initWithChannel:tickChannel.channel isAudioEvent:YES isLinkedEvent:NO lastLinkedEvent:nil fragments:nil]];
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
    
    // check for a hit (collected audio events for this tick match solution events for this tick)
    if ([self.solutionSequence tick:self.currentTick doesMatchAudioEventsInGroup:combinedEvents]) {
        NSLog(@"HIT");
        [self.hits addObject:@(YES)];
    }
    else {
        NSLog(@"MISS");
        [self.hits addObject:@(NO)];
    }
    
    // notify UI elements of our hits status
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTickHit object:nil userInfo:@{kKeyHits : self.hits}];

    // hand over events to synth class which talks to PD patch
    [MainSynth receiveEvents:combinedEvents ignoreAudioPad:NO];
    
    // advance cells, tick counter
    for (TickChannel *tickChannel in self.channels) {
        tickChannel.currentCell = [tickChannel nextCell];
    }
    self.currentTick++;
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
