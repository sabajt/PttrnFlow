//
//  Drum.m
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "Sample.h"
#import "CCNode+Grid.h"
#import "ColorUtils.h"

@interface Sample ()

@property (weak, nonatomic) CCSprite *onSprite;
// fragments
@property (copy, nonatomic) NSString *sampleName;

@end

@implementation Sample

- (id)initWithCell:(Coord *)cell sampleName:(NSString *)sampleName frameName:(NSString *)frameName
{
    self = [super initWithSpriteFrameName:frameName];
    if (self) {
        self.color = [ColorUtils cream];
        self.sampleName = sampleName;
        
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
    return @[self.sampleName];
}

@end
