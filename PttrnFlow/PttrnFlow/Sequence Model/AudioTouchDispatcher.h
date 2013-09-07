//
//  AudioTouchDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "TickResponder.h"

@interface AudioTouchDispatcher : CCNode <CCTargetedTouchDelegate>

- (void)addResponder:(id<TickResponder>)responder;
- (void)clearResponders;

@end
