//
//  BasicButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "TouchSprite.h"

@class BasicButton;

@protocol BasicButtonDelegate <NSObject>

- (void)basicButtonPressed:(BasicButton *)sender;

@end

@interface BasicButton : TouchSprite

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName
                      offFrameName:(NSString *)offFrameName
                       onFrameName:(NSString *)onFrameName
                          delegate:(id<BasicButtonDelegate>)delegate;

@end