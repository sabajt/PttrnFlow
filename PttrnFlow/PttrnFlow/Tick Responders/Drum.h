//
//  Drum.h
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@interface Drum : CCSprite <AudioResponder>

- (id)initWithCell:(Coord *)cell audioID:(NSNumber *)audioID data:(NSArray *)data isStatic:(BOOL)isStatic;

@end
