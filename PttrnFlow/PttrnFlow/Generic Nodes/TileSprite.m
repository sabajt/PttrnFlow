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
    return [self initWithTileFrameName:name repeatHorizonal:repeatHorizontal repeatVertical:repeatVertical skip:0];
    
}

- (id)initWithTileFrameName:(NSString *)name repeatHorizonal:(int)repeatHorizontal repeatVertical:(int)repeatVertical skip:(NSInteger)skip
{
    self = [super initWithSpriteFrameName:kClearRectUILayer];
    if (self)
    {
        CCSprite *tileSprite = [CCSprite spriteWithSpriteFrameName:name];
        self.contentSize = CGSizeMake(tileSprite.contentSize.width * repeatHorizontal * (skip + 1), tileSprite.contentSize.height * repeatVertical * (skip + 1));
        
        for (int x = 0; x < repeatHorizontal; x++) {
            for (int y = 0; y < repeatVertical; y++) {
                CCSprite *spr = [CCSprite spriteWithSpriteFrameName:name];
                spr.anchorPoint = ccp(0, 0);
                spr.position = ccp(x * spr.contentSize.width * (skip + 1), y * spr.contentSize.height * (skip + 1));
                [self addChild:spr];
            }
        }
    }
    return self;}


@end
