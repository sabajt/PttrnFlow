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

//- (void)stopAudioForChannels:(NSSet *)channels
//{
//    NSMutableArray *combined = [NSMutableArray array];
//    for (NSString *channel in channels) {
//        AudioStopEvent *audioStop = [[AudioStopEvent alloc] initWithChannel:channel isAudioEvent:YES];
//        [combined addObject:audioStop];
//    }
//    [[MainSynth sharedMainSynth] receiveEvents:combined ignoreAudioPad:YES];
//}

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
    CCLOG(@"step user sequence index: %i, at cell: %@", self.userSequenceIndex, self.currentCell.stringRep);
    
    // get events
    NSArray *events = [self hitResponders:self.responders atCoord:self.currentCell];
    
    // send events to pd
    [[MainSynth sharedMainSynth] receiveEvents:events ignoreAudioPad:NO];
    
    // change direction if needed
    for (TickEvent *e in events) {
        if ([e isKindOfClass:[DirectionEvent class]]) {
            DirectionEvent *directionEvent = (DirectionEvent *)e;
            self.currentDirection = directionEvent.direction;
            CCLOG(@"changed direction: %@", directionEvent.direction);
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
    CCLOG(@"step sol seq...");
    //    if (self.sequenceIndex >= self.sequenceLength) {
    //        [self unschedule:@selector(advanceSequence)];
    //        [self stopAudioForChannels:self.solutionChannels];
    //        return;
    //    }
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAdvancedSequence object:nil userInfo:@{kKeySequenceIndex:@(self.sequenceIndex)}];
    //    [self play:self.sequenceIndex];
    //    self.sequenceIndex++;
}

#pragma mark - SequenceControlDelegate

- (void)startUserSequence
{
    CCLOG(@"start user seq at cell %@, direction: %@", self.entry.cell.stringRep, self.entry.direction);
    
    self.userSequenceIndex = 0;
    self.currentCell = self.entry.cell;
    self.currentDirection = self.entry.direction;
    
    //    [self.dynamicChannels removeAllObjects];
    //    [self.hits removeAllObjects];
    
    //    for (TickChannel *channel in self.channels) {
    //        [channel reset];
    //    }
    
    [self schedule:@selector(stepUserSequence:) interval:kSequenceInterval];
}

- (void)stopUserSequence
{
    CCLOG(@"stop user seq...");
    [self unschedule:@selector(stepUserSequence:)];
    
    //    NSMutableSet *channels = [NSMutableSet set];
    //    NSSet *tickChannels = [self.channels setByAddingObjectsFromSet:self.dynamicChannels];
    //    for (TickChannel *ch in tickChannels) {
    //        [channels addObject:ch.channel];
    //    }
    //    [self stopAudioForChannels:channels];
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
