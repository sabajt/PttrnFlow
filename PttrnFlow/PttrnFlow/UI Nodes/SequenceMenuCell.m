//
//  SequenceMenuCell.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "SequenceMenuCell.h"
#import "PFLColorUtils.h"

@interface SequenceMenuCell ()

@property (assign) int index;

@end


@implementation SequenceMenuCell

-(id) initWithIndex:(int)index
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(320, 50);
        self.swallowsTouches = YES;
        _index = index;
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", index + 1] fontName:@"Helvetica" fontSize:40];
        label.color = ccWHITE;
        label.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:label];
    }
    return self;
}

#pragma mark - TouchNodeDelegate

- (BOOL)containsTouch:(UITouch *)touch
{
    CGPoint touchPosition = [self convertTouchToNodeSpace:touch];
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    return (CGRectContainsPoint(rect, touchPosition));
}

#pragma mark CCTargetedTouchDelegate

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    
    if ([self containsTouch:touch]) {
        [self.menuCellDelegate sequenceMenuCellTouchUpInside:self index:self.index];
    }
}

@end
