//
//  SequenceDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 2/3/14.
//
//

#import "CCNode.h"
#import "SequenceControlsLayer.h"
#import "AudioResponder.h"
#import "Entry.h"

@interface SequenceDispatcher : CCNode <SequenceControlDelegate>

@property (weak, nonatomic) Entry *entry;

- (void)addResponder:(id<AudioResponder>)responder;
- (void)clearResponders;

@end
