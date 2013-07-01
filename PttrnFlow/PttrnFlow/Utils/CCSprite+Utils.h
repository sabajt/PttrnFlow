//
//  CCSprite+Utils.h
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import <UIKit/UIKit.h>
#import "CCSprite.h"

@interface CCSprite (Utils)

+ (CCSprite *)rectSpriteWithSize:(CGSize)size color:(ccColor3B)color;
+ (CCSprite *)rectSpriteWithSize:(CGSize)size edgeLength:(CGFloat)edge color:(ccColor3B)color;

@end
