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

static inline ccColor4B ccc4BFromccc3B(ccColor3B c)
{
    return (ccColor4B){c.r, c.g, c.b, 255};
}

@interface ColorUtils : NSObject

+ (UIColor *)UIColorFor3B:(ccColor3B)color;

+ (ccColor3B)activeYellow;
+ (ccColor3B)cream;
+ (ccColor3B)darkCream;
+ (ccColor3B)darkPurple;
+ (ccColor3B)defaultPurple;
+ (ccColor3B)dimPurple;

#pragma mark - Theme

+ (ccColor3B)audioPanelWithTheme:(NSString *)theme;
+ (ccColor3B)backgroundWithTheme:(NSString *)theme;
+ (ccColor3B)controlButtonsDefaultWithTheme:(NSString *)theme;
+ (ccColor3B)controlButtonsActiveWithTheme:(NSString *)theme;
+ (ccColor3B)controlPanelWithTheme:(NSString *)theme;
+ (ccColor3B)glyphDetailWithTheme:(NSString *)theme;
+ (ccColor3B)padHighlightWithTheme:(NSString *)theme;
+ (ccColor3B)padWithTheme:(NSString *)theme isStatic:(BOOL)isStatic;
+ (ccColor3B)solutionButtonHighlightWithTheme:(NSString *)theme;

@end

