//
//  MultiSampleEvent.h
//  PttrnFlow
//
//  Created by John Saba on 3/1/14.
//
//

#import "TickEvent.h"

@class SampleEvent;

@interface MultiSampleEvent : TickEvent

@property (strong, nonatomic) NSMutableDictionary *samples;

- (id)initWithAudioID:(NSNumber *)audioID timedSamplesData:(NSDictionary *)timedSamplesData;

@end
