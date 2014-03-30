//
//  TileSprite.m
//  PttrnFlow
//
//  Created by John Saba on 11/3/13.
//
//

#import "PFLTileSprite.h"
#import "PFLGameConstants.h"

@implementation PFLTileSprite

- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats skip:(NSInteger)skip
{
    self = [super initWithSpriteFrameName:image];
    if (self)
    {
        self.opacity = 0.0;
        CCSprite *tileSprite = [CCSprite spriteWithSpriteFrameName:image];
        self.contentSize = CGSizeMake(tileSprite.contentSize.width * repeats.x * (skip + 1), tileSprite.contentSize.height * repeats.y * (skip + 1));
        
        for (int x = 0; x < repeats.x; x++) {
            for (int y = 0; y < repeats.y; y++) {
                CCSprite *spr = [CCSprite spriteWithSpriteFrameName:image];
                spr.anchorPoint = ccp(0, 0);
                spr.position = ccp(x * spr.contentSize.width * (skip + 1), y * spr.contentSize.height * (skip + 1));
                [self addChild:spr];
            }
        }
    }
    return self;
}

- (id)initWithImage:(NSString *)image repeats:(CGPoint)repeats color1:(ccColor3B)color1 color2:(ccColor3B)color2
{
    self = [super initWithSpriteFrameName:image];
    if (self)
    {
        self.opacity = 0.0;
        CCSprite *tileSprite = [CCSprite spriteWithSpriteFrameName:image];
        self.contentSize = CGSizeMake(tileSprite.contentSize.width * repeats.x, tileSprite.contentSize.height * repeats.y);
        
        for (int x = 0; x < repeats.x; x++) {
            for (int y = 0; y < repeats.y; y++) {
                CCSprite *spr = [CCSprite spriteWithSpriteFrameName:image];
                spr.anchorPoint = ccp(0, 0);
                spr.position = ccp(x * spr.contentSize.width, y * spr.contentSize.height);
                [self addChild:spr];
                
                if (x % 2 == 0) {
                    if (y % 2 == 0) {
                        spr.color = color1;
                    }
                    else {
                        spr.color = color2;
                    }
                }
                else {
                    if (y % 2 == 0) {
                        spr.color = color2;
                    }
                    else {
                        spr.color = color1;
                    }
                }
            }
        }
    }
    return self;
}


@end
