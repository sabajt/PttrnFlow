//
//  SpritePicker.m
//  PttrnFlow
//
//  Created by John Saba on 7/6/13.
//
//

#import "SpritePicker.h"

@interface SpritePicker ()

@property (strong, nonatomic) NSArray *sprites;

@end


@implementation SpritePicker

- (id)initWithSprites:(NSArray *)sprites
{
    self = [super init];
    if (self) {
        CCSprite *spr = [sprites lastObject];
        self.contentSize = spr.contentSize;
        
        self.sprites = sprites;
        for (CCSprite *spr in sprites) {
            spr.visible = NO;
            spr.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
            [self addChild:spr];
        }
    }
    return self;
}

- (int)numberOfSprites
{
    return self.sprites.count;
}

- (void)pickSprite:(int)index
{
    if (index >= [self numberOfSprites]) {
        return;
    }
    int i = 0;
    for (CCSprite *spr in self.sprites) {
        if (i)
        i++;
    }
}

@end
