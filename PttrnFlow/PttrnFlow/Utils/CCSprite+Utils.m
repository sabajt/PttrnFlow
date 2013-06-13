//
//  CCSprite+Utils.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "CCSprite+Utils.h"
#import "UIImage+Utils.h"

@implementation CCSprite (Utils)

+ (CCSprite *)spriteWithSize:(CGSize)size color:(UIColor *)color key:(NSString *)key
{
    UIImage *image = [UIImage imageWithColor:color size:size];
    return [CCSprite spriteWithCGImage:image.CGImage key:key];
}

@end
