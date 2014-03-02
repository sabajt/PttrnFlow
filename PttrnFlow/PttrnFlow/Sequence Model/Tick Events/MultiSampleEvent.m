//
//  MultiSampleEvent.m
//  PttrnFlow
//
//  Created by John Saba on 3/1/14.
//
//

#import "MultiSampleEvent.h"
#import "SampleEvent.h"

@implementation MultiSampleEvent

- (id)initWithAudioID:(NSNumber *)audioID timedSamplesData:(NSDictionary *)timedSamplesData
{
    self = [super init];
    if (self) {
        self.audioID = audioID;
        
        self.samples = [NSMutableDictionary dictionary];
        [timedSamplesData enumerateKeysAndObjectsUsingBlock:^(NSNumber *time, NSString *file, BOOL *stop) {
            SampleEvent *event = [[SampleEvent alloc] initWithAudioID:audioID sampleName:file];
            self.samples[time] = event;
        }];
    }
    return self;
}

#pragma mark - Subclass hooks

- (NSString *)eventDescription
{
    __block NSString *sampleDescriptions = @"";
    [self.samples enumerateKeysAndObjectsUsingBlock:^(id key, SampleEvent *event, BOOL *stop) {
        sampleDescriptions = [sampleDescriptions stringByAppendingFormat:@"%@\n", [event eventDescription]];
    }];
    return [NSString stringWithFormat:@"%@: { audio ID : %@ } { containing sample events :\n%@\n}", self, self.audioID, sampleDescriptions];
}

@end
