//
//  SequenceDispatcher.m
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "SequenceDispatcher.h"
#import "AudioResponder.h"
#import "CCNode+Grid.h"
#import "NSObject+AudioResponderUtils.h"
#import "TickEvent.h"
#import "MainSynth.h"
#import "DirectionEvent.h"
#import "PuzzleDataManager.h"
#import "SynthEvent.h"
#import "SampleEvent.h"

NSString *const kNotificationStepUserSequence = @"stepUserSequence";
NSString *const kNotificationStepSolutionSequence = @"stepSolutionSequence";
NSString *const kKeyIndex = @"index";

static CGFloat kSequenceInterval = 0.5f;

@interface SequenceDispatcher ()

@property (assign) NSInteger puzzle;
@property (assign) NSInteger userSequenceIndex;
@property (assign) NSInteger solutionSequenceIndex;
@property (strong, nonatomic) NSMutableArray *responders;
@property (strong, nonatomic) Coord *currentCell;
@property (copy, nonatomic) NSString *currentDirection;

/*
 audio events representing solutions at index - ex:
 [ [ event, event ], [ event ], [ event ], [ event, event] ]
 */
@property (strong, nonatomic) NSMutableArray *solutionEvents;

@end

@implementation SequenceDispatcher

- (id)initWithPuzzle:(NSInteger)puzzle
{
    self = [super init];
    if (self) {
        _puzzle = puzzle;
        _responders = [NSMutableArray array];
        [self createSolutionEvents:puzzle];
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

- (void)createSolutionEvents:(NSInteger)puzzle
{
    self.solutionEvents = [NSMutableArray array];
    NSArray *solution = [[PuzzleDataManager sharedManager] puzzleSolution:puzzle];
    NSInteger i = 0;
    
    for (NSDictionary *s in solution) {
        NSString *synthName = s[kSynth];
        NSNumber *midiValue = s[kMidi];
        NSString *sampleName = s[kSample];
        NSMutableArray *currentSolution = [NSMutableArray array];
        
        // pd synth
        if (synthName != NULL && midiValue != NULL) {
            SynthEvent *event = [[SynthEvent alloc] initWithMidiValue:[midiValue stringValue] synthType:synthName];
            [currentSolution addObject:event];
        }
        
        // audio sample
        if (sampleName != NULL) {
            SampleEvent *event = [[SampleEvent alloc] initWithSampleName:sampleName];
            [currentSolution addObject:event];
        }
        
        [self.solutionEvents addObject:currentSolution];
        i++;
    }
}

- (void)stepUserSequence:(ccTime)dt
{
    // get events
    NSArray *events = [self hitResponders:self.responders atCoord:self.currentCell];
    
    // send events to pd
    [[MainSynth sharedMainSynth] receiveEvents:events ignoreAudioPad:NO];
    
    // change direction if needed
    for (TickEvent *e in events) {
        if ([e isKindOfClass:[DirectionEvent class]]) {
            DirectionEvent *directionEvent = (DirectionEvent *)e;
            self.currentDirection = directionEvent.direction;
        }
    }
    
    // hit empty cell
    if (events.count == 0) {
        [self.delegate hitCoordWithNoEvents:self.currentCell];
    }
    
    self.currentCell = [self.currentCell stepInDirection:self.currentDirection];
    self.userSequenceIndex++;
}

- (void)stepSolutionSequence
{
    if (self.solutionSequenceIndex >= self.solutionEvents.count) {
        [self stopUserSequence];
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
    [self schedule:@selector(stepUserSequence:) interval:kSequenceInterval];
}

- (void)stopUserSequence
{
    [self unschedule:@selector(stepUserSequence:)];
}

- (void)startSolutionSequence
{
    self.solutionSequenceIndex = 0;
    [self schedule:@selector(stepSolutionSequence) interval:kSequenceInterval];
}

- (void)stopSolutionSequence
{
    [self unschedule:@selector(stepSolutionSequence)];
}

- (void)playSolutionIndex:(NSInteger)index
{
    [[MainSynth sharedMainSynth] receiveEvents:self.solutionEvents[index] ignoreAudioPad:YES];
}

@end
