//
//  NSObject+AudioDispatcher.m
//  PttrnFlow
//
//  Created by John Saba on 1/10/14.
//
//

#import "NSObject+AudioDispatcher.h"
#import "AudioResponder.h"
#import "Coord.h"

#import "TickDispatcher.h" // TODO: for kBPM, need to change

@implementation NSObject (AudioDispatcher)

// hit and collect fragments at all responders at given coord
- (NSArray *)hitRespondersAtCoord:(Coord *)coord responders:(NSArray *)responders
{
    NSMutableArray *fragments = [NSMutableArray array];
    for (id<AudioResponder> responder in responders) {
        if (![responder conformsToProtocol:@protocol(AudioResponder)]) {
            NSLog(@"warning: %@ does not conform to AudioResponder, aborting.", responder);
            return nil;
        }
        
        GridCoord cell = [responder audioCell];
        Coord *responderCoord = [Coord coordWithX:cell.x Y:cell.y];
        if ([responderCoord isEqualToCoord:coord]) {
            [fragments addObjectsFromArray:[responder audioHit:kBPM]];
        }
    }
    return fragments;
}

@end
