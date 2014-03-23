//
//  Gear.m
//  PttrnFlow
//
//  Created by John Saba on 2/28/14.
//
//

#import "ColorUtils.h"
#import "CCNode+Grid.h"
#import "Gear.h"
#import "PFLEvent.h"
#import "MainSynth.h"
#import "PFLPuzzle.h"
#import "PFLMultiSample.h"
#import "PFLSample.h"
#import "PFLGlyph.h"
#import "PFLPuzzleSet.h"

@interface Gear ()

@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) NSMutableArray *audioUnits;
@property (strong, nonatomic) PFLEvent *multiSampleEvent;

@end

@implementation Gear

- (id)initWithGlyph:(PFLGlyph *)glyph multiSample:(PFLMultiSample *)multiSample
{
    self = [super initWithSpriteFrameName:@"audio_circle.png"];
    if (self) {;
        NSString *theme = glyph.puzzle.puzzleSet.theme;
        self.defaultColor = [ColorUtils glyphDetailWithTheme:theme];
        self.activeColor = [ColorUtils glyphActiveWithTheme:theme];
        self.color = self.defaultColor;
        
        // CCNode+Grid
        self.cell = glyph.cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        
        // units (beats)
        self.audioUnits = [NSMutableArray array];
        for (PFLSample *sample in multiSample.samples) {
            
            // container
            CCSprite *container = [CCSprite spriteWithSpriteFrameName:@"audio_box_empty.png"];
            container.rotation = 360.0f * [sample.time floatValue];
            container.position = ccp(self.contentSize.width / 2.0f, self.contentSize.height / 2.0f);
            
            // audio unit
            CCSprite *audioUnit = [CCSprite spriteWithSpriteFrameName:@"audio_unit.png"];
            static CGFloat unitPadding = 4.0f;
            audioUnit.position = ccp(container.contentSize.width / 2, (container.contentSize.height - audioUnit.contentSize.height / 2) - unitPadding);
            audioUnit.color = [ColorUtils glyphDetailWithTheme:theme];
            
            // unit symbol
            CCSprite *unitSymbol = [CCSprite spriteWithSpriteFrameName:sample.image];
            unitSymbol.color = [ColorUtils padWithTheme:theme isStatic:glyph.isStatic];
            CGFloat symbolPadding = 2.0f;
            unitSymbol.position = ccp(audioUnit.contentSize.width / 2.0f, audioUnit.contentSize.height / 2.0f + symbolPadding);
            
            [audioUnit addChild:unitSymbol];
            [container addChild:audioUnit];
            [self addChild:container];

            [self.audioUnits addObject:audioUnit];
        }
        self.multiSampleEvent = [PFLEvent multiSampleEventWithAudioID:glyph.audioID multiSample:multiSample];
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
    CCTintTo *tint1 = [CCTintTo actionWithDuration:beatDuration * 2.0f red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:[CCEaseSineOut actionWithAction:tint1]];
    
    for (CCSprite *unit in self.audioUnits) {
        unit.color = self.activeColor;
        CCTintTo *tint2 = [CCTintTo actionWithDuration:beatDuration * 2.0f red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
        [unit runAction:[CCEaseSineOut actionWithAction:tint2]];
    }
    
    CCRotateBy *rotate = [CCRotateBy actionWithDuration:beatDuration angle:360.0f];
    [self runAction:[CCEaseSineOut actionWithAction:rotate]];
    
    return self.multiSampleEvent;
}

@end
