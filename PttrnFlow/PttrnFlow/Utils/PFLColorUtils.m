//
//  ColorUtils.m
//  PttrnFlow
//
//  Created by John Saba on 2/4/13.
//
//

#import "PFLColorUtils.h"

NSString *const kPFLColorUtilsPurpleTheme = @"purple";
NSString *const kPFLColorUtilsLightPurpleTheme = @"purple_light";

@implementation PFLColorUtils

#pragma mark - conversions

+ (UIColor *)UIColorFor3B:(ccColor3B)color
{
    CGFloat red = (CGFloat)color.r;
    CGFloat green = (CGFloat)color.g;
    CGFloat blue = (CGFloat)color.b;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

#pragma mark - Colors

+ (ccColor3B)activeYellow
{
    return ccc3(255, 212, 39);
}

+ (ccColor3B)cream
{
//    return ccc3(252, 251, 247); // original
    return ccc3(232, 231, 227); // darker
}

+ (ccColor3B)darkCream
{
    return ccc3(222, 221, 217);
}

+ (ccColor3B)darkGray
{
    return ccc3(43, 43, 43);
}

+ (ccColor3B)darkPurple
{
    return ccc3(102, 77, 102);
}

+ (ccColor3B)defaultPurple
{
    return ccc3(157, 79, 140);
}

+ (ccColor3B)dimPurple
{
    return ccc3(155, 138, 159);
}

+ (ccColor3B)lightPurple
{
    return ccc3(227, 222, 238);
}

#pragma mark - Themes

+ (ccColor3B)audioPanelEdgeWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)audioPanelFillWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)backgroundWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkGray];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils lightPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)controlButtonsDefaultWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)controlButtonsActiveWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)controlPanelEdgeWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils dimPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)controlPanelFillWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)glyphActiveWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)glyphDetailWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkCream];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)padHighlightWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)padWithTheme:(NSString *)theme isStatic:(BOOL)isStatic
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        if (isStatic) {
            return [PFLColorUtils dimPurple];
        }
        return [PFLColorUtils defaultPurple];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        if (isStatic) {
            return [PFLColorUtils dimPurple];
        }
        return [PFLColorUtils defaultPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

+ (ccColor3B)solutionButtonHighlightWithTheme:(NSString *)theme
{
    if ([theme isEqualToString:kPFLColorUtilsPurpleTheme]) {
        return [PFLColorUtils activeYellow];
    }
    else if ([theme isEqualToString:kPFLColorUtilsLightPurpleTheme]) {
        return [PFLColorUtils darkPurple];
    }
    CCLOG(@"Warning theme '%@' not recognized", theme);
    return ccBLACK;
}

@end
