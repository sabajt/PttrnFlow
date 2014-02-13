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

- (id)initWithPlaceholderFrameName:(NSString *)placeholderFrameName
                      offFrameName:(NSString *)offFrameName
                       onFrameName:(NSString *)onFrameName
                          delegate:(id<ToggleButtonDelegate>)delegate;
- (id)initWithFrameName:(NSString *)frameName
           defaultColor:(ccColor3B)defaultColor
            activeColor:(ccColor3B)activeColor
               delegate:(id<ToggleButtonDelegate>)delegate;
- (void)toggle;

@end
