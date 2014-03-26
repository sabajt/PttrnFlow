//
//  PFLTransitionSlide.h
//  PttrnFlow
//
//  Created by John Saba on 3/25/14.
//
//

#import "CCTransition.h"

@interface PFLTransitionSlide : CCTransitionScene;

- (id)initWithDuration:(ccTime)t scene:(CCScene *)s forwards:(BOOL)forwards leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

@end
