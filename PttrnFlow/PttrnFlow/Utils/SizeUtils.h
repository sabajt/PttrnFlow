//
//  SizeUtils.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import <Foundation/Foundation.h>

@interface SizeUtils : NSObject

// size is usually auto-converted internally, use this when drawing directly into context
+ (CGSize)correctedSize:(CGSize)size;
+ (CGFloat)correctedFloat:(CGFloat)f;

@end
