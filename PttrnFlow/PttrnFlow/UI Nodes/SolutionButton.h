//
//  SolutionButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/15/14.
//
//

#import "TouchSprite.h"

@class SolutionButton;

@protocol SolutionButtonDelegate <NSObject>

- (void)solutionButtonPressed:(SolutionButton *)button;

@end

@interface SolutionButton : TouchSprite

@property (assign) NSInteger index;

- (id)initWithIndex:(NSInteger)index delegate:(id<SolutionButtonDelegate>)delegate;
- (void)press;

@end
