//
//  SampleEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "TickEvent.h"

@interface SampleEvent : TickEvent

@property (copy, nonatomic) NSString *fileName;

- (id)initWithAudioID:(NSNumber *)audioID sampleName:(NSString *)name;

@end
