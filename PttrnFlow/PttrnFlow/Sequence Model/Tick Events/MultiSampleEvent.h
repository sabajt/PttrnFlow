//
//  MultiSampleEvent.h
//  PttrnFlow
//
//  Created by John Saba on 3/1/14.
//
//

#import "TickEvent.h"

@interface MultiSampleEvent : TickEvent

- (id)initWithAudioID:(NSNumber *)audioID timedSamplesData:(NSDictionary *)timedSamplesData;

@property (strong, nonatomic) NSMutableDictionary *samples;

@end
