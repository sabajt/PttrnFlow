//
//  Entry.h
//  PttrnFlow
//
//  Created by John Saba on 2/2/14.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@class Coord;

@interface Entry : CCSprite <AudioResponder>

@property (copy, nonatomic) NSString *direction;

- (id)initWithCell:(Coord *)cell direction:(NSString *)direction isStatic:(BOOL)isStatic;

@end

