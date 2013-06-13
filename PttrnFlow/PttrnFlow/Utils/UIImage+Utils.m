//
//  UIImage+Utils.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

+(UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
