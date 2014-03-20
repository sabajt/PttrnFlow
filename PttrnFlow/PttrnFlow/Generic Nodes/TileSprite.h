//
//  TileSprite.h
//  PttrnFlow
//
//  Created by John Saba on 11/3/13.
//
//

#import "CCSprite.h"

@interface TileSprite : CCSprite

- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats skip:(NSInteger)skip;
- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats color1:(ccColor3B)color1 color2:(ccColor3B)color2;

@end
