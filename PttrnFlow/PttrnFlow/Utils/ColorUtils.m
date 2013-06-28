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

+ (ccColor3B)darkBlue
{
    return ccc3(20, 50, 60);
}

+ (ccColor3B)gray
{
    return ccc3(150, 150, 150);
}

+ (ccColor3B)lime
{
    return ccc3(30, 255, 40);
}

+ (ccColor3B)orange
{
    return ccc3(255, 180, 50);
}

#pragma mark - public colors by context

+ (ccColor3B)sequenceHud
{
    return [self darkBlue];
}

+ (ccColor3B)ticker
{
    return [self lime];
}

+ (ccColor3B)tickerBar
{
    return [self gray];
}

+ (ccColor3B)sequenceMenuCell
{
    return [self gray];
}

+ (ccColor3B)sequenceMenuCellLabel
{
    return [self darkBlue];
}

+ (ccColor3B)exitFaderBlock
{
    return [self gray];
}

+ (ccColor3B)winningBackground
{
    return [self orange];
}

@end
