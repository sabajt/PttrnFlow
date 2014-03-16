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
#import "MultiSampleEvent.h"
#import "MainSynth.h"
#import "PFLPuzzle.h"

@interface Gear ()

@property (assign) ccColor3B defaultColor;
@property (assign) ccColor3B activeColor;
@property (strong, nonatomic) NSMutableArray *audioUnits;
@property (strong, nonatomic) MultiSampleEvent *multiSampleEvent;

@end

@implementation Gear

- (id)initWithCell:(Coord *)cell audioID:(NSNumber *)audioID data:(NSArray *)data isStatic:(BOOL)isStatic
{
    self = [super initWithSpriteFrameName:@"audio_circle.png"];
    if (self) {
        self.defaultColor = [ColorUtils cream];
        self.activeColor = [ColorUtils activeYellow];
        self.color = self.defaultColor;
        
        // CCNode+Grid
        self.cell = cell;
        self.cellSize = CGSizeMake(kSizeGridUnit, kSizeGridUnit);
        
        // units (beats)
        NSMutableDictionary *multiSampleData = [NSMutableDictionary dictionary];
        self.audioUnits = [NSMutableArray array];
        for (NSDictionary *unit in data) {
            
            // container
            CCSprite *container = [CCSprite spriteWithSpriteFrameName:@"audio_box_empty.png"];
            NSNumber *time = unit[kPuzzleTime];
            container.rotation = 360.0f * [time floatValue];
            container.position = ccp(self.contentSize.width / 2.0f, self.contentSize.height / 2.0f);
            container.color = ccORANGE;
            
            // audio unit
            CCSprite *audioUnit = [CCSprite spriteWithSpriteFrameName:@"audio_unit.png"];
            static CGFloat unitPadding = 4.0f;
            audioUnit.position = ccp(container.contentSize.width / 2, (container.contentSize.height - audioUnit.contentSize.height / 2) - unitPadding);
            audioUnit.color = [ColorUtils cream];
            
            // unit symbol
            CCSprite *unitSymbol = [CCSprite spriteWithSpriteFrameName:unit[kPuzzleImage]];
            if (isStatic) {
                unitSymbol.color = [ColorUtils dimPurple];
            }
            else {
                unitSymbol.color = [ColorUtils defaultPurple];
            }
            CGFloat symbolPadding = 2.0f;
            unitSymbol.position = ccp(audioUnit.contentSize.width / 2.0f, audioUnit.contentSize.height / 2.0f + symbolPadding);
            
            [audioUnit addChild:unitSymbol];
            [container addChild:audioUnit];
            [self addChild:container];

            [self.audioUnits addObject:audioUnit];
            
            // add data for our multi-sample event
            multiSampleData[time] = unit[kPuzzleFile];
        }
        
        self.multiSampleEvent = [[MultiSampleEvent alloc] initWithAudioID:audioID timedSamplesData:[NSDictionary dictionaryWithDictionary:multiSampleData]];
    }
    return self;
}

#pragma mark - AudioResponder

- (Coord *)audioCell
{
    return self.cell;
}

- (TickEvent *)audioHit:(CGFloat)beatDuration
{
    self.color = self.activeColor;
    CCTintTo *tint1 = [CCTintTo actionWithDuration:beatDuration red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
    [self runAction:[CCEaseSineOut actionWithAction:tint1]];
    
    for (CCSprite *unit in self.audioUnits) {
        unit.color = self.activeColor;
        CCTintTo *tint2 = [CCTintTo actionWithDuration:beatDuration red:self.defaultColor.r green:self.defaultColor.g blue:self.defaultColor.b];
        [unit runAction:[CCEaseSineOut actionWithAction:tint2]];
    }
    
    CCRotateBy *rotate = [CCRotateBy actionWithDuration:beatDuration angle:360.0f];
    [self runAction:[CCEaseSineOut actionWithAction:rotate]];
    
    return self.multiSampleEvent;
}

@end
