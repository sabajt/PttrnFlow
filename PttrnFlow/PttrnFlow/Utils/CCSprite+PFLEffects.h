//
//  CCSprite+PFLEffects.h
//  PttrnFlow
//
//  Created by John Saba on 3/20/14.
//
//

#import "CCSprite.h"

@interface CCSprite (PFLEffects)

- (void)backlight:(CGFloat)beatDuration completion:(void (^)(void))completion;

@end
