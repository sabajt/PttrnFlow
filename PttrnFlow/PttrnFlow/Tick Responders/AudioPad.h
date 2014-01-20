//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class Coord;

@interface AudioPad : CCSprite <AudioResponder>

@property (assign) BOOL isStatic;

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName cell:(Coord *)cell isStatic:(BOOL)isStatic;

@end
