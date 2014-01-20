//
//  Arrow.m
//  PttrnFlow
//
//  Created by John Saba on 1/20/14.
//
//

#import "Arrow.h"
#import "NSString+Degrees.h"
#import "CCNode+Grid.h"

@interface Arrow ()

@property (copy, nonatomic) NSString *direction;
@property (weak, nonatomic) CCSprite *onSprite;

@end

@implementation Arrow

- (id)initWithCell:(Coord *)cell direction:(NSString *)direction isStatic:(BOOL)isStatic
{
    NSString *frameNameOff = @"arrow_up_off.png";
    NSString *frameNameOn = @"arrow_up_on.png";
    if (isStatic) {
        frameNameOff = @"arrow_up_off_static.png";
        frameNameOn = @"arrow_up_on_static.png";
    }
    self = [super initWithSpriteFrameName:frameNameOff];
    if (self) {
        self.direction = direction;
        self.rotation = [direction degrees];
        
        CCSprite *onSprite = [CCSprite spriteWithSpriteFrameName:frameNameOn];
        self.onSprite = onSprite;
        onSprite.opacity = 0.0;
        onSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
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
    
    return @[self.direction];
}

@end
