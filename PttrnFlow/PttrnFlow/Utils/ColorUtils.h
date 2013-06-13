//
//  ColorUtils.h
//  SequencerGame
//
//  Created by John Saba on 2/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ColorUtils : NSObject

+ (UIColor *)UIColorFor3B:(ccColor3B)color;

+ (ccColor3B)ticker;
+ (ccColor3B)tickerBar;
+ (ccColor3B)sequenceMenuCell;
+ (ccColor3B)sequenceMenuCellLabel;

@end

