//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "GameSprite.h"
#import "AudioResponder.h"

@interface AudioPad : GameSprite <AudioResponder>

- (id)initWithCell:(GridCoord)cell;

@end
