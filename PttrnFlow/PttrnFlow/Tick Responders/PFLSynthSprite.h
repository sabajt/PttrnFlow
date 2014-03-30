//
//  Synth.h
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "CCSprite.h"
#import "PFLAudioResponder.h"

@interface PFLSynthSprite : CCSprite <PFLAudioResponder>

- (id)initWithCell:(PFLCoord *)cell
           audioID:(NSNumber *)audioID
             synth:(NSString *)synth
              midi:(NSNumber *)midi
             image:(NSString *)image
         decorator:(NSString *)decorator;

@end
