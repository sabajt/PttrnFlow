//
//  Gear.h
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"

@class PFLGlyph, PFLMultiSample;

@interface PFLGearSprite : CCSprite <PFLAudioResponder>

- (id)initWithGlyph:(PFLGlyph *)glyph multiSample:(PFLMultiSample *)multiSample;

@end
