//
//  AudioTouchDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "AudioResponder.h"
#import "PanLayer.h"

@interface AudioTouchDispatcher : CCNode <CCTargetedTouchDelegate, PanLayerDelegate>

@property (assign) BOOL allowScrolling;

+ (AudioTouchDispatcher *)sharedAudioTouchDispatcher;

- (void)addResponder:(id<AudioResponder>)responder;
- (void)clearResponders;

@end
