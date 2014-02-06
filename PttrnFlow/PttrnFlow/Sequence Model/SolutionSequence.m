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
#import "TickEvent.h"

@interface SolutionSequence ()

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
        
        self.sequence = [NSArray arrayWithArray:tempSequence];
    }
    return self;
}

- (id)eventFromSolutionRepresentation:(NSDictionary *)eventData
{
    NSString *eventType = [eventData objectForKey:@"event_type"];
    
    if ([eventType isEqualToString:@"synth"]) {
        NSString *channel = [eventData objectForKey:@"channel"];
        NSString *midiValue = [eventData objectForKey:@"midi_value"];
        NSString *synthType = [eventData objectForKey:@"synth_type"];
        
        // synths are uniqued by channel so they can be sent to the unique instances in the pd patch,
        // but for solution checking, the channel itself is arbitrary: channel is how the applicaiton
        // keeps track of last linked events, which is how we check if the solution is correct.
        TickEvent *lastLinkedEvent = self.trackedEvents[channel];
        SynthEvent *event = [[SynthEvent alloc] initWithChannel:channel lastLinkedEvent:lastLinkedEvent midiValue:midiValue synthType:synthType];
        self.trackedEvents[channel] = event;
        
        return event;
    }

    return nil;
}

- (BOOL)tick:(int)tick doesMatchAudioEventsInGroup:(NSArray *)events
{
    NSArray *incomingAudioEvents = [events audioEvents];
    NSArray *solutionEvents = self.sequence[tick];
    return [incomingAudioEvents hasSameNumberOfSameEvents:solutionEvents];
}

@end
