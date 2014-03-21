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
#import "ColorUtils.h"
#import "PFLEvent.h"

@interface Arrow ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation Arrow

- (id)initWithCell:(Coord *)cell direction:(NSString *)direction isStatic:(BOOL)isStatic
{
    self = [super initWithSpriteFrameName:@"glyph_circle.png"];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        self.rotation = [direction degrees];
        
        self.event = [PFLEvent directionEventWithDirection:direction];
        
        CCSprite *detailSprite = [CCSprite spriteWithSpriteFrameName:@"arrow_up.png"];
        self.detailSprite = detailSprite;
        detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:detailSprite];
        if (isStatic) {
            detailSprite.color = [ColorUtils dimPurple];
        }
        else {
            detailSprite.color = [ColorUtils defaultPurple];
        }
        
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

- (PFLEvent *)audioHit:(CGFloat)beatDuration
{
    self.color = self.activeColor;
    CCTintTo *tint = [CCTintTo actionWithDuration:beatDuration * 2.0f red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:[CCEaseSineOut actionWithAction:tint]];
    
    return self.event;
}

@end
