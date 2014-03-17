//
//  ToggleButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "TouchSprite.h"

@class ToggleButton;

@protocol ToggleButtonDelegate <NSObject>

- (void)toggleButtonPressed:(ToggleButton *)sender;

@end

@interface ToggleButton : TouchSprite

@property (assign) BOOL isOn;

- (id)initWithPlaceholderImage:(NSString *)placeholderImage offImage:(NSString *)offImage onImage:(NSString *)onImage delegate:(id<ToggleButtonDelegate>)delegate;
- (id)initWithImage:(NSString *)image defaultColor:(ccColor3B)defaultColor activeColor:(ccColor3B)activeColor delegate:(id<ToggleButtonDelegate>)delegate;
- (void)toggle;

@end
