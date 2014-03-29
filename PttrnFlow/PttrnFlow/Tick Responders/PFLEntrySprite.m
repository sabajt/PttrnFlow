//
//  Entry.m
//  PttrnFlow
//
//  Created by John Saba on 2/2/14.
//
//

#import "PFLEntrySprite.h"
#import "NSString+Degrees.h"
#import "CCNode+Grid.h"
#import "PFLColorUtils.h"
#import "PFLEvent.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"
#import "PFLPuzzle.h"

@interface PFLEntrySprite ()

@property (weak, nonatomic) CCSprite *detailSprite;
@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) PFLEvent *event;

@end

@implementation PFLEntrySprite

- (id)initWithGlyph:(PFLGlyph *)glyph
{
    self = [super initWithSpriteFrameName:@"glyph_circle.png"];
    if (self) {
        NSString *theme = glyph.puzzle.puzzleSet.theme;
        self.defaultColor = [PFLColorUtils glyphDetailWithTheme:theme];
        self.activeColor = [PFLColorUtils glyphActiveWithTheme:theme];
        self.color = self.defaultColor;
        self.direction = glyph.entry;
        self.rotation = [self.direction degrees];
        
        self.event = [PFLEvent directionEventWithDirection:self.direction];
        
        CCSprite *detailSprite = [CCSprite spriteWithSpriteFrameName:@"entry_up.png"];
        self.detailSprite = detailSprite;
        detailSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:detailSprite];
        detailSprite.color = [PFLColorUtils padWithTheme:theme isStatic:glyph.isStatic];
        
        // CCNode+Grid
        self.cell = glyph.cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
    }
    return self;
}

#pragma mark - AudioResponder

- (PFLCoord *)audioCell
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
