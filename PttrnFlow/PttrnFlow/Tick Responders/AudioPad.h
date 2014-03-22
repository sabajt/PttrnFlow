//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class PFLGlyph;

@interface AudioPad : CCSprite <AudioResponder>

@property (assign) BOOL isStatic;

- (id)initWithGlyph:(PFLGlyph *)glyph;

@end
