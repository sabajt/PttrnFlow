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

+ (ccColor3B)cream
{
    return ccc3(252, 251, 247);
}

+ (ccColor3B)activeYellow
{
    return ccc3(255, 212, 39);
}

@end
