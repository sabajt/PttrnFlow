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

@implementation CCSprite (Utils)

+ (CCSprite *)spriteWithSize:(CGSize)size color:(ccColor3B)color key:(NSString *)key
{   
    UIImage *image = [UIImage imageWithColor:[ColorUtils UIColorFor3B:color] size:size];
    return [CCSprite spriteWithCGImage:image.CGImage key:key];
}

@end
    