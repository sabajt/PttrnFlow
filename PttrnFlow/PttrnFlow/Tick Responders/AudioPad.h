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

@property (assign) BOOL moveable;

- (id)initWithCell:(GridCoord)cell moveable:(BOOL)moveable;

@end
