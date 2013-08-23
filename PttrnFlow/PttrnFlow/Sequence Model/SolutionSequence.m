//
//  SolutionSequence.m
//  PttrnFlow
//
//  Created by John Saba on 8/19/13.
//
//

#import "SolutionSequence.h"
#import "SynthEvent.h"
#import "SampleEvent.h"
#import "AudioStopEvent.h"

@interface SolutionSequence ()

@property (strong, nonatomic) NSArray *sequence;
@property (strong, nonatomic) NSMutableDictionary *trackedEvents;

@end

@implementation SolutionSequence

- (id)initWithSolution:(NSString *)solution
{
    self = [super init];
    if (self) {
        // get solution json
        NSString *path = [[NSBundle mainBundle] pathForResource:solution ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error != nil) {
            NSLog(@"solution sequence error parsing json: %@", error.description);
        }
        
        NSLog(@"json sequence: %@", json);
        
        self.trackedEvents = [NSMutableDictionary dictionary];
        NSMutableArray *tempSequence = [NSMutableArray array];
        
        // create ordered events at each sub-tick (quarter-tick) from json
        // [ [event, event, event], [event, event], [], [event, event], [event], [], etc... ]
        int numberOfTicks = json.count;
        int solutionIndex = 0;
        for (int t = 1; t <= numberOfTicks; t++) {
            NSDictionary *tick = [json objectForKey:[@"tick_" stringByAppendingFormat:@"%i", t]];
            for (int q = 1; q <= 4; q++) {
                NSMutableArray *tickEvents = [NSMutableArray array];
                NSArray *quarter = [tick objectForKey:[@"sub_" stringByAppendingFormat:@"%i", q]];
                for (NSDictionary *eventData in quarter) {
                    id event = [self eventFromSolutionRepresentation:eventData];
                    [tickEvents addObject:event];
                }
                [tempSequence addObject:tickEvents];
                solutionIndex++;
            }
        }
        
        NSLog(@"event sequence: %@", tempSequence);
        
        self.sequence = [NSArray arrayWithArray:tempSequence];
    }
    return self;
}

- (id)eventFromSolutionRepresentation:(NSDictionary *)eventData
{
    NSString *eventType = [eventData objectForKey:@"event_type"];
    
    if ([eventType isEqualToString:@"synth"]) {
        NSNumber *uid = [eventData objectForKey:@"uid"];
        NSString *midiValue = [eventData objectForKey:@"midi_value"];
        NSString *synthType = [eventData objectForKey:@"synth_type"];
        
        // a synth needs to know its last event to check for correct sequence.
        // our solution json uniques synths by 'uid' instead of channel: outside of running a dynamic sequence, channel is arbitrary.
        // to check one series of events against another, we only want to know that
        // the sequence of notes, stops etc are on the same synth, regardless of channel.
        TickEvent *lastEvent = self.trackedEvents[uid];
        SynthEvent *event = [[SynthEvent alloc] initWithChannel:kChannelNone lastLinkedEvent:lastEvent midiValue:midiValue synthType:synthType];
        self.trackedEvents[uid] = event;
        
        return event;
    }
    else if ([eventType isEqualToString:@"audio_stop"]) {
        NSNumber *uid = [eventData objectForKey:@"uid"];
        
        // audio stop may share uid with synth and samples so also needs to track last event
        TickEvent *lastEvent = self.trackedEvents[uid];
        AudioStopEvent *event = [[AudioStopEvent alloc] initWithChannel:kChannelNone lastLinkedEvent:lastEvent fragments:nil];
        self.trackedEvents[uid] = event;
        
        return event;
    }
    else if ([eventType isEqualToString:@"sample"]) {
        NSString *fileName = [eventData objectForKey:@"file_name"];
        
        return [[SampleEvent alloc] initWithChannel:kChannelNone sampleName:fileName];
    }
    return nil;
}

@end
