//
//  SequenceMenuCell.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "SequenceMenuCell.h"
#import "CCSprite+Utils.h"
#import "ColorUtils.h"

@interface SequenceMenuCell ()

@property (weak, nonatomic) CCSprite *sprite;
@property (assign) int index;

@end


@implementation SequenceMenuCell

-(id) initWithIndex:(int)index
{
    static CGFloat width = 200;
    static CGFloat height = 50;

    self = [super init];
    if (self) {
        self.touchNodeDelegate = self;
        
        self.contentSize = CGSizeMake(width, height);
        self.swallowsTouches = YES;
        _index = index;
        
        CCSprite *sprite = [CCSprite rectSpriteWithSize:CGSizeMake(width, height) color:[ColorUtils sequenceMenuCell]];
        _sprite = sprite;
        _sprite.position = ccp(width/2, height/2);
        [self addChild:_sprite];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", index + 1] fontName:@"Helvetica" fontSize:20];
        label.color = [ColorUtils sequenceMenuCellLabel];
        label.position = ccp(_sprite.contentSize.width/2, _sprite.contentSize.height/2);
        [_sprite addChild:label]; 
        
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
    
    if ([self.touchNodeDelegate containsTouch:touch]) {
        [self.menuCellDelegate sequenceMenuCellTouchUpInside:self index:self.index];
    }
}

@end
