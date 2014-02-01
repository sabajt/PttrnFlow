//
//  BackgroundLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/28/13.
//
//

#import "BackgroundLayer.h"
#import "TileSprite.h"
#import "ColorUtils.h"
#import "GameConstants.h"

@implementation BackgroundLayer

+ (BackgroundLayer *)backgroundLayer
{
    BackgroundLayer *layer = [BackgroundLayer layerWithColor:ccc4BFromccc3B([ColorUtils cream])];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:[kTextureKeyBackground stringByAppendingString:@".png"]];
    [layer addChild:batchNode];
    
    CCSprite *tempTile = [CCSprite spriteWithSpriteFrameName:@"background_tile.png"];
    NSInteger repeatHorizontal = (NSInteger)((layer.contentSize.width / tempTile.contentSize.width) / 2) + 2;
    NSInteger repeatVertical = (NSInteger)((layer.contentSize.height / tempTile.contentSize.height) / 2) + 2;
    
    TileSprite *background1 = [[TileSprite alloc] initWithTileFrameName:@"background_tile.png" placeholderFrameName:@"clear_rect_background.png" repeatHorizonal:repeatHorizontal repeatVertical:repeatVertical skip:1];
    background1.position = ccp(layer.contentSize.width / 2, layer.contentSize.height / 2);
    [batchNode addChild:background1];

    TileSprite *background2 = [[TileSprite alloc] initWithTileFrameName:@"background_tile.png" placeholderFrameName:@"clear_rect_background.png" repeatHorizonal:repeatHorizontal repeatVertical:repeatVertical skip:1];
    background2.position = ccp(background1.position.x - tempTile.contentSize.width, background1.position.y - tempTile.contentSize.height);
    [batchNode addChild:background2];
    
    return layer;
}

- (void)tintToColor:(ccColor3B)color duration:(ccTime)duration
{
    CCTintTo *tint = [CCTintTo actionWithDuration:duration red:color.r green:color.g blue:color.b];
    [self runAction:tint];
}

@end
