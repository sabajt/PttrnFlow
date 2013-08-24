//
//  AudioTouchDispatcher.m
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "AudioTouchDispatcher.h"
#import "TickEvent.h"
#import "MainSynth.h"

@interface AudioTouchDispatcher ()

@property (strong, nonatomic) NSMutableDictionary *currentFragments;

@end

@implementation AudioTouchDispatcher

- (id)init
{
    self = [super init];
    if (self) {
        _currentFragments = [NSMutableDictionary dictionary];
    }
    return self;
}

//
- (void)addFragments:(NSArray *)fragments channel:(NSString *)channel
{
    NSMutableArray *storedFragments = [self.currentFragments objectForKey:channel];
    if (storedFragments == nil) {
        storedFragments = [NSMutableArray array];
    }
    [storedFragments addObjectsFromArray:fragments];
    [self.currentFragments setObject:storedFragments forKey:channel];
}

- (void)sendAudio:(NSString *)channel
{
    NSArray *fragments = [self.currentFragments objectForKey:channel];
    NSArray *events = [TickEvent eventsFromFragments:self.currentFragments[channel] channel:channel lastLinkedEvents:nil];
}

@end
