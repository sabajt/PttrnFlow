//
//  TickEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/12/13.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kChannelNone;

@interface NSArray (TickEvents)

- (BOOL)hasSameNumberOfSameEvents:(NSArray *)events;
- (NSArray *)audioEvents;

@end

@interface TickEvent : NSObject

@property (copy, nonatomic) NSString *channel;
@property (assign) BOOL isAudioEvent;
@property (assign) BOOL isLinkedEvent;
@property (strong, nonatomic) TickEvent *lastLinkedEvent;

- (id)initWithChannel:(NSString *)channel isAudioEvent:(BOOL)isAudioEvent isLinkedEvent:(BOOL)isLinkedEvent lastLinkedEvent:(TickEvent *)lastLinkedEvent fragments:(NSArray *)fragments;
- (id)initWithChannel:(NSString *)channel isAudioEvent:(BOOL)isAudioEvent;
- (BOOL)isEqualToEvent:(TickEvent *)event checkLastLinkedEvent:(BOOL)checkLastLinkedEvent;

@end
