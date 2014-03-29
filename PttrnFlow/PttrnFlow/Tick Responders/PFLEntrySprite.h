//
//  Entry.h
//  PttrnFlow
//
//  Created by John Saba on 2/2/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class PFLGlyph;

@interface PFLEntrySprite : CCSprite <AudioResponder>

@property (copy, nonatomic) NSString *direction;

- (id)initWithGlyph:(PFLGlyph *)glyph;

@end

