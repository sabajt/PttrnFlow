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
@property (assign) BOOL isDisplaced;

- (id)initWithPlaceholderImage:(NSString *)placeholderImage size:(CGSize)size index:(NSInteger)index defaultColor:(ccColor3B)defaultColor activeColor:(ccColor3B)activeColor delegate:(id<SolutionButtonDelegate>)delegate;
- (void)press;
- (void)animateCorrectHit:(BOOL)correct;
- (void)reset;

@end
