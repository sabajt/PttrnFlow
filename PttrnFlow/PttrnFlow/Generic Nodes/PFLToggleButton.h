//
//  ToggleButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/19/14.
//
//

#import "PFLTouchSprite.h"

@class PFLToggleButton;

@protocol ToggleButtonDelegate <NSObject>

- (void)toggleButtonPressed:(PFLToggleButton *)sender;

@end

@interface PFLToggleButton : PFLTouchSprite

@property (assign) BOOL isOn;

- (id)initWithPlaceholderImage:(NSString *)placeholderImage offImage:(NSString *)offImage onImage:(NSString *)onImage delegate:(id<ToggleButtonDelegate>)delegate;
- (id)initWithImage:(NSString *)image defaultColor:(ccColor3B)defaultColor activeColor:(ccColor3B)activeColor delegate:(id<ToggleButtonDelegate>)delegate;
- (void)toggle;

@end
