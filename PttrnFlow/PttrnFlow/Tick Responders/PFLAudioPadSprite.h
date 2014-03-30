//
//  AudioPad.h
//  PttrnFlow
//
//  Created by John Saba on 8/25/13.
//
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"

@class PFLGlyph;

@interface PFLAudioPadSprite : CCSprite <PFLAudioResponder>

@property (assign) BOOL isStatic;

- (id)initWithGlyph:(PFLGlyph *)glyph;

@end
