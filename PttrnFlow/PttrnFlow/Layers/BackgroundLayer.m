//
//  BackgroundLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/28/13.
//
//

#import "BackgroundLayer.h"
#import "CCSprite+Utils.h"

@implementation BackgroundLayer

+ (BackgroundLayer *)backgroundLayer
{
    BackgroundLayer *layer = [[self alloc] init];
    CCSprite *backgroundImage = [CCSprite spriteWithSpriteFrameName:@"background_checkers.png"];
    backgroundImage.position = ccp(layer.contentSize.width / 2, layer.contentSize.height / 2);
    [layer addChild:backgroundImage];
    return layer;
}

- (void)tintToColor:(ccColor3B)color duration:(ccTime)duration
{
    CCTintTo *tint = [CCTintTo actionWithDuration:duration red:color.r green:color.g blue:color.b];
    [self runAction:tint];
}

@end
