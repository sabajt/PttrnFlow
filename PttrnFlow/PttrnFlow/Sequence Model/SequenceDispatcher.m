//
//  SequenceDispatcher.m
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "AudioResponder.h"
#import "SequenceDispatcher.h"
#import "CCNode+Grid.h"
#import "MainSynth.h"
#import "NSObject+AudioResponderUtils.h"
#import "TickEvent.h"
#import "PFLPuzzle.h"

NSString *const kNotificationStepUserSequence = @"stepUserSequence";
NSString *const kNotificationStepSolutionSequence = @"stepSolutionSequence";
NSString *const kNotificationEndUserSequence = @"endUserSequence";
NSString *const kNotificationEndSolutionSequence = @"endSolutionSequence";
NSString *const kKeyIndex = @"index";
NSString *const kKeyCoord = @"coord";
NSString *const kKeyCorrectHit = @"correctHit";
NSString *const kKeyEmpty = @"empty";

@interface SequenceDispatcher ()

@property (assign) PFLPuzzle *puzzle;
@property (assign) NSInteger userSequenceIndex;
@property (assign) NSInteger solutionSequenceIndex;
@property (strong, nonatomic) NSMutableArray *responders;
@property (strong, nonatomic) Coord *currentCell;
@property (copy, nonatomic) NSString *currentDirection;

/*
 audio events representing solutions at index - ex:
 [ [ event, event ], [ event ], [ event ], [ event, event] ]
 */
@property (strong, nonatomic) NSArray *solutionEvents;

@end

@implementation SequenceDispatcher

- (id)initWithPuzzle:(PFLPuzzle *)puzzle
{
    self = [super init];
    if (self) {
        self.puzzle = puzzle;
        _responders = [NSMutableArray array];
        // TODO: FIX ME
        self.beatDuration = 0.5f;
        self.solutionEvents = [TickEvent puzzleSolutionEvents:puzzle];
    }
    return self;
}

- (void)addResponder:(id<AudioResponder>)responder
{
    [self.responders addObject:responder];
}

- (void)clearResponders
{
    [self.responders removeAllObjects];
}

- (void)stepUserSequence:(ccTime)dt
{    
    if (self.userSequenceIndex >= self.solutionEvents.count) {
        // use notification instead of stopUserSequence so SequenceControlsLayer can toggle button off
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEndUserSequence object:nil];
        return;
    }
    
    // get events
    NSArray *events = [self hitResponders:self.responders atCoord:self.currentCell];
    
    // send events to pd
    [[MainSynth sharedMainSynth] receiveEvents:events];
    
    // change direction if needed
    for (TickEvent *e in events) {
        if (e.eventType == PFLSequenceEventDirection) {
            self.currentDirection = e.direction;
        }
    }
    
    BOOL correctHit = NO;
    NSArray *solutionEvents = self.solutionEvents[self.userSequenceIndex];
    if ([[events audioEvents] hasSameNumberOfSameEvents:solutionEvents]) {
        CCLOG(@"hit");
        correctHit = YES;
    }
    else {
        CCLOG(@"miss");
    }
    
    NSDictionary *info = @{
        kKeyIndex : @(self.userSequenceIndex),
        kKeyCoord : self.currentCell,
        kKeyCorrectHit : @(correctHit),
        kKeyEmpty : @(events.count == 0)
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStepUserSequence object:nil userInfo:info];

    self.currentCell = [self.currentCell stepInDirection:self.currentDirection];
    self.userSequenceIndex++;
}

- (void)stepSolutionSequence
{
    if (self.solutionSequenceIndex >= self.solutionEvents.count) {
        // use notification instead of stopSolutionSequence so SequenceControlsLayer can toggle button off
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEndSolutionSequence object:nil];
        return;
    }
    // use notification instead of playSolutionIndex so we can get the button highlight too.
    NSDictionary *info = @{ kKeyIndex : @(self.solutionSequenceIndex) };
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStepSolutionSequence object:nil userInfo:info];
    self.solutionSequenceIndex++;
}

#pragma mark - SequenceControlDelegate

- (void)startUserSequence
{
    self.userSequenceIndex = 0;
    self.currentCell = self.entry.cell;
    self.currentDirection = self.entry.direction;
    [self schedule:@selector(stepUserSequence:) interval:self.beatDuration];
}

- (void)stopUserSequence
{
    [self unschedule:@selector(stepUserSequence:)];
}

- (void)startSolutionSequence
{
    self.solutionSequenceIndex = 0;
    [self schedule:@selector(stepSolutionSequence) interval:self.beatDuration];
}

- (void)stopSolutionSequence
{
    [self unschedule:@selector(stepSolutionSequence)];
}

- (void)playSolutionIndex:(NSInteger)index
{
    [[MainSynth sharedMainSynth] receiveEvents:self.solutionEvents[index]];
}

@end
