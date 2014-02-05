//
//  NSObject+AudioResponderUtils.m
//  PttrnFlow
//
//  Created by John Saba on 1/10/14.
//
//

#import "NSObject+AudioResponderUtils.h"
#import "AudioResponder.h"
#import "Coord.h"

#import "TickDispatcher.h" // TODO: for kBPM, need to change

@implementation NSObject (AudioResponderUtils)

- (NSArray *)responders:(NSArray *)responders atCoord:(Coord *)coord
{
    NSMutableArray *results = [NSMutableArray array];
    for (id<AudioResponder> responder in responders) {
        if (![responder conformsToProtocol:@protocol(AudioResponder)]) {
            NSLog(@"warning: %@ does not conform to AudioResponder, aborting.", responder);
            return nil;
        }
        
        Coord *responderCoord = [responder audioCell];
        CCLOG(@"responder coord: %@", responderCoord.stringRep);
        if ([responderCoord isEqualToCoord:coord]) {
            [results addObject:responder];
        }
    }
    return [NSArray arrayWithArray:results];
}

- (NSArray *)hitResponders:(NSArray *)responders atCoord:(Coord *)coord
{
    // collect fragments from all hit cells
    NSArray *fragments = [NSArray array];
    NSArray *hitResponders = [self responders:responders atCoord:coord];
    for (id<AudioResponder> responder in hitResponders) {
        if (![responder conformsToProtocol:@protocol(AudioResponder)]) {
            NSLog(@"warning: %@ does not conform to AudioResponder, aborting.", responder);
            return nil;
        }

        fragments = [fragments arrayByAddingObjectsFromArray:[responder audioHit:kBPM]];
    }
    return fragments;
}

@end
