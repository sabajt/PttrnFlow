//
//  ColorUtils.h
//  SequencerGame
//
//  Created by John Saba on 2/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

FOUNDATION_EXPORT NSString *const kPFLColorUtilsPurpleTheme;
FOUNDATION_EXPORT NSString *const kPFLColorUtilsLightPurpleTheme;

static inline ccColor4B ccc4BFromccc3B(ccColor3B c)
{
    return (ccColor4B){c.r, c.g, c.b, 255};
}

@interface ColorUtils : NSObject

+ (UIColor *)UIColorFor3B:(ccColor3B)color;

+ (ccColor3B)activeYellow;
+ (ccColor3B)cream;
+ (ccColor3B)darkCream;
+ (ccColor3B)darkGray;
+ (ccColor3B)darkPurple;
+ (ccColor3B)defaultPurple;
+ (ccColor3B)dimPurple;

#pragma mark - Theme

+ (ccColor3B)audioPanelEdgeWithTheme:(NSString *)theme;
+ (ccColor3B)audioPanelFillWithTheme:(NSString *)theme;
+ (ccColor3B)backgroundWithTheme:(NSString *)theme;
+ (ccColor3B)controlButtonsDefaultWithTheme:(NSString *)theme;
+ (ccColor3B)controlButtonsActiveWithTheme:(NSString *)theme;
+ (ccColor3B)controlPanelEdgeWithTheme:(NSString *)theme;
+ (ccColor3B)controlPanelFillWithTheme:(NSString *)theme;
+ (ccColor3B)glyphActiveWithTheme:(NSString *)theme;
+ (ccColor3B)glyphDetailWithTheme:(NSString *)theme;
+ (ccColor3B)padHighlightWithTheme:(NSString *)theme;
+ (ccColor3B)padWithTheme:(NSString *)theme isStatic:(BOOL)isStatic;
+ (ccColor3B)solutionButtonHighlightWithTheme:(NSString *)theme;

@end

