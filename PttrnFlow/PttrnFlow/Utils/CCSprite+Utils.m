//
//  CCSprite+Utils.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "CCSprite+Utils.h"
#import "UIImage+Utils.h"
#import "ColorUtils.h"
#import "AppDelegate.h"
#import "SizeUtils.h"
#import "TextureUtils.h"

@implementation CCSprite (Utils)

// solid rectangle sprite

//+ (CCSprite *)rectSpriteWithSize:(CGSize)size color:(ccColor3B)color
//{
//    // we need to correct the size for retina ourselves because we are drawing into graphics context
//    CGSize correctedSize = [SizeUtils correctedSize:size];
//    NSString *key = [TextureUtils keyForPrimativeWithSize:correctedSize color:color];
//    UIImage *image = [UIImage imageWithColor:[ColorUtils UIColorFor3B:color] size:correctedSize];
//    return [CCSprite spriteWithCGImage:image.CGImage key:key];
//}

+ (CCSprite *)rectSpriteWithSize:(CGSize)size color:(ccColor3B)color
{
    CCSprite *spr = [CCSprite spriteWithFile:@"white_rect.png"];
    [spr setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    spr.color = color;
    return spr;
}

// rectangle sprite with defined edges and clear center
+ (CCSprite *)rectSpriteWithSize:(CGSize)size edgeLength:(CGFloat)edge edgeColor:(ccColor3B)edgeColor
{
    UIColor *uiColor = [ColorUtils UIColorFor3B:edgeColor];
    
    // we need to correct sizes for retina ourselves because we are drawing into graphics context
    CGSize correctedSize = [SizeUtils correctedSize:size];
    CGFloat correctedEdge = [SizeUtils correctedFloat:edge];
    
    // create sides
    CGSize verticalSize = CGSizeMake(correctedEdge, correctedSize.height);
    CGSize horizontalSize = CGSizeMake(correctedSize.width, correctedEdge);
    
    NSString *verticalKey = [TextureUtils keyForPrimativeWithSize:verticalSize color:edgeColor];
    NSString *horizontalKey = [TextureUtils keyForPrimativeWithSize:horizontalSize color:edgeColor];
    
    UIImage *verticalImage = [UIImage imageWithColor:uiColor size:verticalSize];
    UIImage *horizontalImage = [UIImage imageWithColor:uiColor size:horizontalSize];
    
    CCSprite *leftSprite = [CCSprite spriteWithCGImage:verticalImage.CGImage key:verticalKey];
    CCSprite *rightSprite = [CCSprite spriteWithCGImage:verticalImage.CGImage key:verticalKey];
    CCSprite *topSprite = [CCSprite spriteWithCGImage:horizontalImage.CGImage key:horizontalKey];
    CCSprite *bottomSprite = [CCSprite spriteWithCGImage:horizontalImage.CGImage key:horizontalKey];
    
    CCSprite *container = [[CCSprite alloc] init];
    
    container.contentSize = size;
    leftSprite.position = ccp(leftSprite.contentSize.width/2, container.contentSize.height/2);
    rightSprite.position = ccp(container.contentSize.width - rightSprite.contentSize.width/2, container.contentSize.height/2);
    topSprite.position = ccp(container.contentSize.width/2, container.contentSize.height - topSprite.contentSize.height/2);
    bottomSprite.position = ccp(container.contentSize.width/2, bottomSprite.contentSize.height/2);
    
    [container addChild:leftSprite];
    [container addChild:rightSprite];
    [container addChild:topSprite];
    [container addChild:bottomSprite];

    return container;
}

// rectangle sprite with defined edges, and defined color for edges and center
+ (CCSprite *)rectSpriteWithSize:(CGSize)size edgeLength:(CGFloat)edge edgeColor:(ccColor3B)edgeColor centerColor:(ccColor3B)centerColor
{
    UIColor *uiColor = [ColorUtils UIColorFor3B:edgeColor];
    
    // we need to correct sizes for retina ourselves because we are drawing into graphics context
    CGSize correctedSize = [SizeUtils correctedSize:size];
    CGFloat correctedEdge = [SizeUtils correctedFloat:edge];
    
    // create sides
    CGSize verticalSize = CGSizeMake(correctedEdge, correctedSize.height);
    CGSize horizontalSize = CGSizeMake(correctedSize.width, correctedEdge);
    
    NSString *verticalKey = [TextureUtils keyForPrimativeWithSize:verticalSize color:edgeColor];
    NSString *horizontalKey = [TextureUtils keyForPrimativeWithSize:horizontalSize color:edgeColor];
    
    UIImage *verticalImage = [UIImage imageWithColor:uiColor size:verticalSize];
    UIImage *horizontalImage = [UIImage imageWithColor:uiColor size:horizontalSize];
    
    CCSprite *leftSprite = [CCSprite spriteWithCGImage:verticalImage.CGImage key:verticalKey];
    CCSprite *rightSprite = [CCSprite spriteWithCGImage:verticalImage.CGImage key:verticalKey];
    CCSprite *topSprite = [CCSprite spriteWithCGImage:horizontalImage.CGImage key:horizontalKey];
    CCSprite *bottomSprite = [CCSprite spriteWithCGImage:horizontalImage.CGImage key:horizontalKey];
    
    UIColor *uiContainerColor = [ColorUtils UIColorFor3B:centerColor];
    UIImage *containerImage = [UIImage imageWithColor:uiContainerColor size:correctedSize];
    NSString *containerKey = [TextureUtils keyForPrimativeWithSize:correctedSize color:centerColor];
    CCSprite *container = [CCSprite spriteWithCGImage:containerImage.CGImage key:containerKey];
    
    leftSprite.position = ccp(leftSprite.contentSize.width/2, container.contentSize.height/2);
    rightSprite.position = ccp(container.contentSize.width - rightSprite.contentSize.width/2, container.contentSize.height/2);
    topSprite.position = ccp(container.contentSize.width/2, container.contentSize.height - topSprite.contentSize.height/2);
    bottomSprite.position = ccp(container.contentSize.width/2, bottomSprite.contentSize.height/2);
    
    [container addChild:leftSprite];
    [container addChild:rightSprite];
    [container addChild:topSprite];
    [container addChild:bottomSprite];
    
    return container;
}

@end
    