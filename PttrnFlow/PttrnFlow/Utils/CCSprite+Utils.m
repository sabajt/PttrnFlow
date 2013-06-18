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

@implementation CCSprite (Utils)

+ (CCSprite *)spriteWithSize:(CGSize)size color:(ccColor3B)color key:(NSString *)key
{
    CGSize correctedSize  = size;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.isRetinaEnabled) {
        correctedSize = CGSizeMake(size.width * 2, size.height * 2);
    }
    UIImage *image = [UIImage imageWithColor:[ColorUtils UIColorFor3B:color] size:correctedSize];
    return [CCSprite spriteWithCGImage:image.CGImage key:key];
}

@end
    