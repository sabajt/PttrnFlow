//
//  TouchNode.h
//  PttrnFlow
//
//  Created by John Saba on 6/14/13.
//
//

#import "cocos2d.h"

@interface TouchNode : CCNode <CCTargetedTouchDelegate>

@property (assign) BOOL swallowsTouches;
@property (assign) CGFloat longPressDelay;

- (void)longPress:(ccTime)deltaTime;

@end
