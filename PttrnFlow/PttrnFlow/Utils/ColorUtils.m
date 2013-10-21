//
//  ColorUtils.m
//  PttrnFlow
//
//  Created by John Saba on 2/4/13.
//
//

#import "ColorUtils.h"

@implementation ColorUtils

#pragma mark - conversions

+ (UIColor *)UIColorFor3B:(ccColor3B)color
{
    CGFloat red = (CGFloat)color.r;
    CGFloat green = (CGFloat)color.g;
    CGFloat blue = (CGFloat)color.b;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

#pragma mark - colors

+ (ccColor3B)backgroundGray
{
    return ccc3(49, 49, 49);
}

+ (ccColor3B)defaultSteel
{
    return ccc3(124, 152, 162);
}

+ (ccColor3B)highlightRed
{
    return ccc3(173, 61, 105);
}

+ (ccColor3B)skyBlue
{
    return ccc3(203, 226, 238);
}

@end
