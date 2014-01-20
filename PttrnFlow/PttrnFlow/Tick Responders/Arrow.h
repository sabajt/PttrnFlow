//
//  Arrow.h
//  PttrnFlow
//
//  Created by John Saba on 1/20/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class Coord;

@interface Arrow : CCSprite <AudioResponder>

- (id)initWithCell:(Coord *)cell direction:(NSString *)direction isStatic:(BOOL)isStatic;

@end
