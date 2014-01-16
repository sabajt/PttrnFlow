//
//  Synth.h
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "CCSprite.h"
#import "AudioResponder.h"

@interface Synth : CCSprite <AudioResponder>

- (id)initWithCell:(Coord *)cell synth:(NSString *)synth midi:(NSString *)midi frameName:(NSString *)frameName;

@end
