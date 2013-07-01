//
//  SizeUtils.m
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "SizeUtils.h"
#import "AppDelegate.h"

@implementation SizeUtils

// size is usually auto-converted internally, use this when drawing directly into context
+ (CGSize)correctedSize:(CGSize)size
{
    CGSize correctedSize  = size;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.isRetinaEnabled) {
        correctedSize = CGSizeMake(size.width * 2, size.height * 2);
    }
    return correctedSize;
}

+ (CGFloat)correctedFloat:(CGFloat)f
{
    CGFloat correctedFloat = f;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.isRetinaEnabled) {
        correctedFloat *= 2;
    }
    return correctedFloat;
}

@end
