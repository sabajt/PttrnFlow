//
//  TouchSprite.h
//  PttrnFlow
//
//  Created by John Saba on 9/9/13.
//
//

#import "cocos2d.h"
#import "TouchNode.h"

@interface TouchSprite : CCSprite <CCTargetedTouchDelegate>

@property (weak, nonatomic) id<TouchNodeDelegate>touchNodeDelegate;

@property (assign) BOOL swallowsTouches;
@property (assign) CGFloat longPressDelay;
@property (assign) BOOL isReceivingTouch;

- (void)longPress:(ccTime)deltaTime;

@end
