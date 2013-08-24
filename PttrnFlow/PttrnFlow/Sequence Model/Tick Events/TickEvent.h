//
//  TickEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT int const kChannelNone;

@interface NSArray (TickEvents)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events;
- (NSArray *)audioEvents;

@end

@interface TickEvent : NSObject

@property (assign) int channel;
@property (assign) BOOL isAudioEvent;
@property (strong, nonatomic) TickEvent *lastLinkedEvent;

- (id)initWithChannel:(int)channel isAudioEvent:(BOOL)isAudioEvent lastLinkedEvent:(TickEvent *)lastLinkedEvent fragments:(NSArray *)fragments;
- (BOOL)isEqualToEvent:(TickEvent *)event checkLastLinkedEvent:(BOOL)checkLastLinkedEvent;

#pragma mark - Creation Utils
+ (NSArray *)eventsFromFragments:(NSArray *)fragments channel:(int)channel lastLinkedEvents:(NSDictionary *)lastLinkedEvents;

@end
