//
//  NSObject+AudioResponderUtils.m
//  PttrnFlow
//
//  Created by John Saba on 1/10/14.
//
//

#import "PFLAudioResponder.h"
#import "PFLCoord.h"
#import "NSObject+PFLAudioResponderUtils.h"
#import <objc/runtime.h>

@implementation NSObject (PFLAudioResponderUtils)

@dynamic beatDuration;

- (void)setBeatDuration:(CGFloat)beatDuration
{
    objc_setAssociatedObject(self, @selector(beatDuration), @(beatDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)beatDuration
{
    return [objc_getAssociatedObject(self, @selector(beatDuration)) floatValue];
}

- (NSArray *)responders:(NSArray *)responders atCoord:(PFLCoord *)coord
{
    NSMutableArray *results = [NSMutableArray array];
    for (id<PFLAudioResponder> responder in responders) {
        if (![responder conformsToProtocol:@protocol(PFLAudioResponder)]) {
            CCLOG(@"warning: %@ does not conform to AudioResponder, aborting.", responder);
            return nil;
        }
        
        PFLCoord *responderCoord = [responder audioCell];
        if ([responderCoord isEqualToCoord:coord]) {
            [results addObject:responder];
        }
    }
    return [NSArray arrayWithArray:results];
}

- (NSArray *)hitResponders:(NSArray *)responders atCoord:(PFLCoord *)coord
{
    // collect events from all hit cells
    NSArray *events = [NSArray array];
    NSArray *hitResponders = [self responders:responders atCoord:coord];
    for (id<PFLAudioResponder> responder in hitResponders) {
        if (![responder conformsToProtocol:@protocol(PFLAudioResponder)]) {
            CCLOG(@"warning: %@ does not conform to AudioResponder, aborting.", responder);
            return nil;
        }
        
        PFLEvent *event = [responder audioHit:self.beatDuration];
        if (event) {
            events = [events arrayByAddingObject:event];
        }
    }
    return events;
}

@end
