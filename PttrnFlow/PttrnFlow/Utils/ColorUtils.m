//
//  ColorUtils.m
//  SequencerGame
//
//  Created by John Saba on 2/4/13.
//
//

#import "ColorUtils.h"

@implementation ColorUtils

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

#pragma mark - colors named by object

// colors named by object

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
    return [self lime];
}

@end
