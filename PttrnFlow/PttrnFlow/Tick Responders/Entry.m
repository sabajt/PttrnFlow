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

@interface Entry ()

@property (copy, nonatomic) NSString *direction;
@property (weak, nonatomic) CCSprite *detailSprite;
@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;

@end

@implementation Entry

- (id)initWithCell:(Coord *)cell direction:(NSString *)direction isStatic:(BOOL)isStatic
{
    self = [super initWithSpriteFrameName:@"glyph_circle.png"];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        self.direction = direction;
        self.rotation = [direction degrees];
        
        CCSprite *detailSprite = [CCSprite spriteWithSpriteFrameName:@"entry_up.png"];
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

- (NSArray *)audioHit:(NSInteger)bpm
{
    self.color = self.activeColor;
    CCTintTo *tint = [CCTintTo actionWithDuration:1 red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:tint];
    
    return @[self.direction];
}

@end