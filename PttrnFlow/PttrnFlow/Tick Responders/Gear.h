//
//  Gear.h
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class PFLMultiSample;

@interface Gear : CCSprite <AudioResponder>

- (id)initWithCell:(Coord *)cell audioID:(NSNumber *)audioID multiSample:(PFLMultiSample *)multiSample isStatic:(BOOL)isStatic;

@end
