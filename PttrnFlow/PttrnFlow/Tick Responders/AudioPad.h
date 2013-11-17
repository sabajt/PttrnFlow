//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "GameSprite.h"
#import "TickResponder.h"

@interface AudioPad : GameSprite <TickResponder>

- (id)initWithCell:(GridCoord)cell;

@end
