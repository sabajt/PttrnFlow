//
//  MultiSampleEvent.h
//  PttrnFlow
//
//  Created by John Saba on 3/1/14.
//
//

#import "TickEvent.h"

@class SampleEvent;

@protocol MultiSampleEventDelegate <NSObject>

- (void)receiveSampleEvent:(SampleEvent *)event;

@end

@interface MultiSampleEvent : TickEvent

@property (weak, nonatomic) id<MultiSampleEventDelegate> delegate;

@end
