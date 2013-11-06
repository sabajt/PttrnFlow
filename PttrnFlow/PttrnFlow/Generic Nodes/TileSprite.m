//
//  TileSprite.m
//  PttrnFlow
//
//  Created by John Saba on 11/3/13.
//
//

#import "TileSprite.h"
#import "GameConstants.h"

@implementation TileSprite

- (id)initWithTileFrameName:(NSString *)name repeatHorizonal:(int)repeatHorizontal repeatVertical:(int)repeatVertical
{
    self = [super initWithSpriteFrameName:kClearRectUILayer];
    if (self)
    {
        CCSprite *tileSprite = [CCSprite spriteWithSpriteFrameName:name];
        self.contentSize = CGSizeMake(tileSprite.contentSize.width * repeatHorizontal, tileSprite.contentSize.height * repeatVertical);
        
        for (int x = 0; x < repeatHorizontal; x++) {
            for (int y = 0; y < repeatVertical; y++) {
                CCSprite *spr = [CCSprite spriteWithSpriteFrameName:name];
                spr.anchorPoint = ccp(0, 0);
                spr.position = ccp(x * spr.contentSize.width, y * spr.contentSize.height);
                [self addChild:spr];
            }
        }
    }
    return self;
}

@end
