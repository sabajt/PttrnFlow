//
//  Tone.h
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "GameSprite.h"
#import "TickResponder.h"

@interface Tone : CCSprite <TickResponder>

- (id)initWithCell:(GridCoord)cell synth:(NSString *)synth midi:(NSString *)midi;

@end
