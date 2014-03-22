//
//  Arrow.h
//  PttrnFlow
//
//  Created by John Saba on 1/20/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class PFLGlyph;

@interface Arrow : CCSprite <AudioResponder>

- (id)initWithGlyph:(PFLGlyph *)glyph;

@end
