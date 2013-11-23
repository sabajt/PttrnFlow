//
//  AudioTouchDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "AudioResponder.h"

@interface AudioTouchDispatcher : CCNode <CCTargetedTouchDelegate>

- (void)addResponder:(id<AudioResponder>)responder;
- (void)clearResponders;

@end
