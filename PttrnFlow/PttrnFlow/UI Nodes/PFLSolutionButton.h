//
//  PFLSolutionButton.h
//  PttrnFlow
//
//  Created by John Saba on 1/15/14.
//
//

#import "PFLTouchSprite.h"

@class PFLSolutionButton;

@protocol PFLSolutionButtonDelegate <NSObject>

- (void)solutionButtonPressed:(PFLSolutionButton *)button;

@end

@interface PFLSolutionButton : PFLTouchSprite

@property (assign) NSInteger index;
@property (assign) BOOL isDisplaced;

- (id)initWithPlaceholderImage:(NSString *)placeholderImage size:(CGSize)size index:(NSInteger)index defaultColor:(ccColor3B)defaultColor activeColor:(ccColor3B)activeColor delegate:(id<PFLSolutionButtonDelegate>)delegate;
- (void)press;
- (void)animateCorrectHit:(BOOL)correct;
- (void)reset;

@end
