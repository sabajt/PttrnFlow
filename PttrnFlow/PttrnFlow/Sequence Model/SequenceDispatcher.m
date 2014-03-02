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
#import "AudioStopEvent.h"

NSString *const kNotificationStepUserSequence = @"stepUserSequence";
NSString *const kNotificationStepSolutionSequence = @"stepSolutionSequence";
NSString *const kNotificationEndUserSequence = @"endUserSequence";
NSString *const kNotificationEndSolutionSequence = @"endSolutionSequence";
NSString *const kKeyIndex = @"index";
NSString *const kKeyCoord = @"coord";
NSString *const kKeyCorrectHit = @"correctHit";
NSString *const kKeyEmpty = @"empty";

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

    for (NSDictionary *s in solution) {
        NSMutableArray *currentSolution = [NSMutableArray array];
        
        for (NSNumber *audioID in s) {
            NSDictionary *data = [[PuzzleDataManager sharedManager] puzzle:puzzle audioID:[audioID integerValue]];
            NSDictionary *tone = data[kTone];
            NSDictionary *drums = data[kDrums];
            
            if (tone) {
                NSString *file = tone[kFile];
                NSString *synth = tone[kSynth];
                NSNumber *midi = tone[kMidi];
                if (file) {
                    SampleEvent *event = [[SampleEvent alloc] initWithAudioID:audioID sampleName:file];
                    [currentSolution addObject:event];
                }
                else if (synth && midi) {
                    SynthEvent *event = [[SynthEvent alloc] initWithAudioID:audioID midiValue:[midi stringValue] synthType:synth];
                    [currentSolution addObject:event];
                }
            }
            else if (drums) {
                // TODO: placeholder event until drums are implemented
                AudioStopEvent *event = [[AudioStopEvent alloc] initWithAudioID:audioID];
                [currentSolution addObject:event];
            }
        }
        [self.solutionEvents addObject:currentSolution];
    }
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
    [[MainSynth sharedMainSynth] receiveEvents:events ignoreAudioPad:NO];
    
    // change direction if needed
    for (TickEvent *e in events) {
        if ([e isKindOfClass:[DirectionEvent class]]) {
            DirectionEvent *directionEvent = (DirectionEvent *)e;
            self.currentDirection = directionEvent.direction;
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
