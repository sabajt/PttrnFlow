//
//  AudioTouchDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import "AudioResponder.h"
#import "ScrollLayer.h"

@interface AudioTouchDispatcher : CCNode <CCTargetedTouchDelegate, ScrollLayerDelegate>

@property (assign) BOOL allowScrolling;
@property (strong, nonatomic) NSArray *areaCells;

- (void)addResponder:(id<AudioResponder>)responder;
- (void)clearResponders;

@end
