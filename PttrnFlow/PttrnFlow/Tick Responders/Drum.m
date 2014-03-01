//
//  Drum.m
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "ColorUtils.h"
#import "CCNode+Grid.h"
#import "Drum.h"
#import "PuzzleDataManager.h"

#import "TickEvent.h"

@interface Drum ()

@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) NSMutableArray *drumUnits;

@end

@implementation Drum

- (id)initWithCell:(Coord *)cell audioID:(NSNumber *)audioID data:(NSArray *)data isStatic:(BOOL)isStatic
{
    self = [super initWithSpriteFrameName:@"drum_ring.png"];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        
        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        
        // units (beats)
        self.drumUnits = [NSMutableArray array];
        for (NSDictionary *unit in data) {
            CCSprite *drumUnit = [CCSprite spriteWithSpriteFrameName:@"drum_unit.png"];
            drumUnit.color = [ColorUtils cream];
    
            CGFloat radius = self.contentSize.width / 2.0f;
            CGFloat time = [unit[kTime] floatValue];
            CGFloat radians = (90.0f - (time * 360.0f)) * (M_PI / 180.0f);
            CGPoint circularPos = ccp(cosf(radians) * radius, sinf(radians) * radius);
            drumUnit.position = ccp((self.contentSize.width / 2.0f) + circularPos.x, (self.contentSize.height / 2.0f) + circularPos.y);
            
            CCSprite *unitSymbol = [CCSprite spriteWithSpriteFrameName:unit[kImage]];
            if (isStatic) {
                unitSymbol.color = [ColorUtils dimPurple];
            }
            else {
                unitSymbol.color = [ColorUtils defaultPurple];
            }
            unitSymbol.position = ccp(drumUnit.contentSize.width / 2.0f, drumUnit.contentSize.height / 2.0f);
            [drumUnit addChild:unitSymbol];
            
            [self addChild:drumUnit];
            [self.drumUnits addObject:drumUnit];
        }
    }
    return self;
}

#pragma mark - AudioResponder

- (Coord *)audioCell
{
    return self.cell;
}

- (TickEvent *)audioHit:(NSInteger)bpm
{
    self.color = self.activeColor;
    CCTintTo *tint1 = [CCTintTo actionWithDuration:1 red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:tint1];
    
    for (CCSprite *unit in self.drumUnits) {
        unit.color = self.activeColor;
        CCTintTo *tint2 = [CCTintTo actionWithDuration:1 red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
        [unit runAction:tint2];
    }
    
    return [[TickEvent alloc] init];
}

@end
