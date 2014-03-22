//
//  Gear.h
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class PFLGlyph, PFLMultiSample;

@interface Gear : CCSprite <AudioResponder>

- (id)initWithGlyph:(PFLGlyph *)glyph multiSample:(PFLMultiSample *)multiSample;

@end
