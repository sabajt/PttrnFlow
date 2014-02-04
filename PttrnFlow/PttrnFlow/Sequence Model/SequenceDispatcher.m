//
//  SequenceDispatcher.m
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "SequenceDispatcher.h"
#import "AudioResponder.h"

static CGFloat kSequenceInterval = 0.5f;

@interface SequenceDispatcher ()

@property (assign) NSInteger userSequenceIndex;
@property (assign) NSInteger solutionSequenceIndex;
@property (weak, nonatomic) NSMutableArray *responders;

@end

@implementation SequenceDispatcher

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

- (void)stepUserSequence:(ccTime)dt
{
    NSLog(@"step user seq...");
}

- (void)stepSolutionSequence
{
    NSLog(@"step sol seq...");
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
    NSLog(@"start user seq...");
    self.userSequenceIndex = 0;
    
    //    [self.dynamicChannels removeAllObjects];
    //    [self.hits removeAllObjects];
    
    //    for (TickChannel *channel in self.channels) {
    //        [channel reset];
    //    }
    
    [self schedule:@selector(stepUserSequence:) interval:kSequenceInterval];
}

- (void)stopUserSequence
{
    NSLog(@"stop user seq...");
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
    NSLog(@"start sol seq...");
    self.solutionSequenceIndex = 0;
    //    [self.solutionChannels removeAllObjects];
    [self schedule:@selector(stepSolutionSequence) interval:kSequenceInterval];
}

- (void)stopSolutionSequence
{
    NSLog(@"stop sol seq...");
    [self unschedule:@selector(stepSolutionSequence)];
}

- (void)playSolutionIndex:(NSInteger)index
{
    NSLog(@"play sol index: %i", index);
    //    if ((index >= self.solutionSequence.sequence.count) || (index < 0)) {
    //        NSLog(@"warning: index out of TickDispatcher range");
    //        return;
    //    }
    //
    //    NSArray *events = [self.solutionSequence.sequence objectAtIndex:index];
    //    [[MainSynth sharedMainSynth] receiveEvents:events ignoreAudioPad:YES];
    //
    //    for (TickEvent *event in events) {
    //        [self.solutionChannels addObject:event.channel];
    //    }
}

@end
