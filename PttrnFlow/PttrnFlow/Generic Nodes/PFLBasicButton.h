//
//  BasicButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "PFLTouchSprite.h"

@class PFLBasicButton;

@protocol BasicButtonDelegate <NSObject>

- (void)basicButtonPressed:(PFLBasicButton *)sender;

@end

@interface PFLBasicButton : PFLTouchSprite

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName
                      offFrameName:(NSString *)offFrameName
                       onFrameName:(NSString *)onFrameName
                          delegate:(id<BasicButtonDelegate>)delegate;
- (id)initWithImage:(NSString *)image defaultColor:(ccColor3B)defaultColor activeColor:(ccColor3B)activeColor delegate:(id<BasicButtonDelegate>)delegate;

@end