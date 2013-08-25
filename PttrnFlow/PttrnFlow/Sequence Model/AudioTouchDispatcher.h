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

@end
