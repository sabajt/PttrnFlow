//
//  Drum.h
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class SampleEvent;

@interface Drum : CCSprite <AudioResponder>

- (id)initWithCell:(Coord *)cell audioID:(NSNumber *)audioID data:(NSArray *)data isStatic:(BOOL)isStatic eventActionRunner:(CCNode *)actionRunner;

@end
