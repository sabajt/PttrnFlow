//
//  AudioTouchDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "TouchNode.h"
#import "TickResponder.h"

@interface AudioTouchDispatcher : TouchNode

- (void)addResponder:(id<TickResponder>)responder;
- (void)clearResponders;
- (void)addFragments:(NSArray *)fragments channel:(NSString *)channel;
- (void)clearFragments;
- (void)sendAudio:(NSString *)channel;

@end
