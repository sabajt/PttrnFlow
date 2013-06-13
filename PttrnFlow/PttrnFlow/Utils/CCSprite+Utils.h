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

+ (CCSprite *)spriteWithSize:(CGSize)size color:(ccColor3B)color key:(NSString *)key;

@end
