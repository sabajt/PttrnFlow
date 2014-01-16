//
//  TouchSprite.h
//  PttrnFlow
//
//  Created by John Saba on 10/26/13.
//
//

#import "cocos2d.h"


@interface TouchSprite : CCSprite <CCTargetedTouchDelegate>

@property (assign) BOOL handleTouches;
@property (assign) BOOL swallowsTouches;
@property (assign) BOOL isReceivingTouch;
@property (assign) CGFloat longPressDelay;

// subclasses may overwrite to define custom touch area (default is bounding box tracked in parent node space)
- (BOOL)containsTouch:(UITouch *)touch;

// set a long press delay to receive this callback
- (void)longPress:(ccTime)deltaTime;

@end