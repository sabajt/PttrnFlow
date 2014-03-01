//
//  MultiSampleEvent.m
//  PttrnFlow
//
//  Created by John Saba on 3/1/14.
//
//

#import "MultiSampleEvent.h"
#import "SampleEvent.h"

@interface MultiSampleEvent ()

@property (strong, nonatomic) NSMutableDictionary *samples;

@end

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

@end
