//
//  Arrow.h
//  PttrnFlow
//
//  Created by John Saba on 1/20/14.
//
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"

@class PFLGlyph;

@interface PFLArrowSprite : CCSprite <PFLAudioResponder>

- (id)initWithGlyph:(PFLGlyph *)glyph;

@end
