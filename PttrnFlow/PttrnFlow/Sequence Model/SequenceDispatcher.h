//
//  SequenceDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "CCNode.h"
#import "SequenceUILayer.h"
#import "AudioResponder.h"

@interface SequenceDispatcher : CCNode <SequenceControlDelegate>

- (void)addResponder:(id<AudioResponder>)responder;
- (void)clearResponders;

@end
