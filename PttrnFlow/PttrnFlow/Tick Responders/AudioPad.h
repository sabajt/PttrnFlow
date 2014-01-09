//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "GameSprite.h"
#import "AudioResponder.h"

@interface AudioPad : CCSprite <AudioResponder>

@property (assign) BOOL isStatic;

- (id)initWithCell:(GridCoord)cell group:(NSNumber *)group isStatic:(BOOL)isStatic;

@end
