//
//  Sample.h
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@interface Sample : CCSprite <AudioResponder>

- (id)initWithCell:(Coord *)cell
           audioID:(NSNumber *)audioID
             image:(NSString *)image
        instrument:(NSString *)instrument
              midi:(NSNumber *)midi;
@end
