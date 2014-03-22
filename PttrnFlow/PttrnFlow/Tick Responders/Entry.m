//
//  Entry.m
//  PttrnFlow
//
//  Created by John Saba on 2/2/14.
//
//

#import "Entry.h"
#import "NSString+Degrees.h"
#import "CCNode+Grid.h"
#import "ColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzle.h"

@interface Entry ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation Entry

- (id)initWithGlyph:(PFLGlyph *)glyph
{
    self = [super initWithSpriteFrameName:@"glyph_circle.png"];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        self.direction = glyph.entry;
        self.rotation = [self.direction degrees];
        
        self.event = [PFLEvent directionEventWithDirection:self.direction];
        
        CCSprite *detailSprite = [CCSprite spriteWithSpriteFrameName:@"entry_up.png"];
        self.detailSprite = detailSprite;
        detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:detailSprite];
        [ColorUtils padWithTheme:glyph.puzzle.puzzleSet.theme isStatic:glyph.isStatic];
        
        // CCNode+Grid
        self.cell = glyph.cell;
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
