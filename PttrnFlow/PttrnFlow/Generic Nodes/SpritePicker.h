//
//  SpritePicker.h
//  PttrnFlow
//
//  Created by John Saba on 7/6/13.
//
//

#import "cocos2d.h"

@interface SpritePicker : CCNode

- (id)initWithSprites:(NSArray *)sprites;
- (int)numberOfSprites;
- (void)pickSprite:(int)index;

@end
