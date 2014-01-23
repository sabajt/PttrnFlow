//
//  Synth.m
//  PttrnFlow
//
//  Created by John Saba on 11/20/13.
//
//

#import "Synth.h"
#import "CCNode+Grid.h"
#import "ColorUtils.h"

@interface Synth ()

@property (weak, nonatomic) CCSprite *onSprite;
// fragments
@property (copy, nonatomic) NSString *synth;
@property (copy, nonatomic) NSString *midi;

@end

@implementation Synth

- (id)initWithCell:(Coord *)cell synth:(NSString *)synth midi:(NSString *)midi frameName:(NSString *)frameName
{
    self = [super initWithSpriteFrameName:frameName];
    if (self) {
        self.color = [ColorUtils cream];
        
        _synth = synth;
        _midi = midi;

        CCSprite *onSprite = [CCSprite spriteWithSpriteFrameName:frameName];
        self.onSprite = onSprite;
        onSprite.color = [ColorUtils activeYellow];
        onSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        onSprite.opacity = 0.0;
        [self addChild:onSprite];
        
        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    
            }
    return self;
}

#pragma mark - AudioResponder

- (Coord *)audioCell
{
    return self.cell;
}

- (NSArray *)audioHit:(NSInteger)bpm
{
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1];
    [self.onSprite runAction:fadeOut];

    return @[self.midi, self.synth];
}

@end

