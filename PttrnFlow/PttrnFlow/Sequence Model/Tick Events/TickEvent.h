//
//  TickEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT int const kChannelNone;

@interface TickEvent : NSObject

@property (assign) int channel;
@property (strong, nonatomic) TickEvent *lastLinkedEvent;

- (id)initWithChannel:(int)channel lastLinkedEvent:(TickEvent *)lastLinkedEvent fragments:(NSArray *)fragments;

#pragma mark - Creation Utils
+ (NSArray *)eventsFromFragments:(NSArray *)fragments channel:(int)channel lastLinkedEvents:(NSDictionary *)lastLinkedEvents;

@end
