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
        _sprites = sprites;
        
        CGSize maxSpriteSize = CGSizeMake(1, 1);
        for (CCSprite *spr in sprites) {
            if (![spr isKindOfClass:[CCSprite class]]) {
                NSLog(@"WARNING: only CCSprite objects can be added to SpritePicker ");
            }
            spr.visible = NO;
            [self addChild:spr];
            
            // remember largest sprite
            CGFloat maxWidth = maxSpriteSize.width;
            CGFloat maxHeight = maxSpriteSize.height;
            if (spr.contentSize.width > maxWidth) {
                maxWidth = spr.contentSize.width;
            }
            if (spr.contentSize.height > maxHeight) {
                maxHeight = spr.contentSize.height;
            }
            maxSpriteSize = CGSizeMake(maxWidth, maxHeight);
        }
        
        // set content size and center sprites
        self.contentSize = maxSpriteSize;
        for (CCSprite *spr in sprites) {
            spr.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
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
        NSLog(@"WARNING: picked sprite out of index");
        return;
    }
    int i = 0;
    for (CCSprite *spr in self.sprites) {
        spr.visible = (i == index);
        i++;
    }
}

- (CCSprite *)spriteAtIndex:(int)index
{
    if (index >= [self numberOfSprites]) {
        NSLog(@"WARNING: tried to return sprite out of index");
        return nil;
    }
    return self.sprites[index];
}

@end
