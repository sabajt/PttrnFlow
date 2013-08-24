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

- (id)initWithChannel:(NSString *)channel sampleName:(NSString *)name;

@end
