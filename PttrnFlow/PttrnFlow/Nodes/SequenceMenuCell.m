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

@end


@implementation SequenceMenuCell

-(id) initWithIndex:(int)index
{
    static CGFloat width = 200;
    static CGFloat height = 50;

    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(width, height);
        
        CCSprite *sprite = [CCSprite spriteWithSize:CGSizeMake(width, height) color:[ColorUtils sequenceMenuCell] key:@"sequenceMenuCell"];
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

@end
