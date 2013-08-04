//
//  WaveTable.m
//  PttrnFlow
//
//  Created by John Saba on 7/28/13.
//
//

#import "WaveTable.h"
#import "PdBase.h"
#import "PdArray.h"
#import "NSArray+CompareNumbers.h"
#import "CCSprite+Utils.h"

#import "SpriteUtils.h"
#import "TextureUtils.h"

@interface WaveTable ()

@property (strong, nonatomic) PdArray *pdArray;
@property (strong, nonatomic) NSArray *reducedArray;
@property (assign) CGSize displaySize;
@property (assign) int samplesPerBlock;

@end


@implementation WaveTable

- (id)initWithTableName:(NSString *)name displaySize:(CGSize)displaySize
{
    self = [super init];
    if (self) {
        self.contentSize = displaySize;
        
        _pdArray = [PdArray arrayNamed:name];
        _displaySize = displaySize;
        _samplesPerBlock = (self.pdArray.size / (int)displaySize.width);
        
        NSMutableArray *tempReducedArray = [NSMutableArray array];
        for (int displayIndex = 0; displayIndex < displaySize.width; displayIndex++) {
            
            // collect samples at specified density
            NSMutableArray *sampleBlock = [NSMutableArray array];
            for (int sampleIndex = 0; sampleIndex < self.samplesPerBlock; sampleIndex++) {
                int pdArrayIndex = (displayIndex * self.samplesPerBlock) + sampleIndex;
                CGFloat sampleValue = [self.pdArray localFloatAtIndex:pdArrayIndex];
                [sampleBlock addObject:@(sampleValue * 100)];
            }
            
            // only max sample gets added to our reduced array
            [tempReducedArray addObject:[sampleBlock maxNumber]];
        }
        _reducedArray = [NSArray arrayWithArray:tempReducedArray];
        
        // set up graph
        CCSprite *sprite = [self spriteWithColor:ccc4FFromccc3B(ccBLACK) textureWidth:displaySize.width textureHeight:displaySize.height];
        
        sprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:sprite];
    }
    return self;
}

- (CCSprite *)spriteWithColor:(ccColor4F)bgColor textureWidth:(float)textureWidth textureHeight:(float)textureHeight {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureWidth height:textureHeight];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    // 3: Draw into the texture
    ccDrawColor4F(1, 1, 1, 1);
	glLineWidth(1.0f);
    
    CGPoint vertices[self.reducedArray.count];
    static float sourceWaveRange = 100;
    int x = 0;
    for (NSNumber *y in self.reducedArray) {
        float yTranslation = sourceWaveRange - ((textureHeight / sourceWaveRange) * [y floatValue]);
        NSLog(@"%f = (%f / %f) * %f", yTranslation, textureHeight, sourceWaveRange, [y floatValue]);
        vertices[x] = ccp(x, yTranslation);
        x++;
    }
    ccDrawPoly(vertices, self.reducedArray.count, NO);
    
    // TODO: if this code is ever used, should move to a graph drawing function -- but will prob trash this class anyway
    x = 1;
    for (NSNumber *y in self.reducedArray) {
        float yTranslation = sourceWaveRange - ((textureHeight / sourceWaveRange) * [y floatValue]);
        NSLog(@"%f = (%f / %f) * %f", yTranslation, textureHeight, sourceWaveRange, [y floatValue]);
        vertices[x] = ccp(x, yTranslation);
        x++;
    }
    ccDrawPoly(vertices, self.reducedArray.count, NO);
    
    x = 2;
    for (NSNumber *y in self.reducedArray) {
        float yTranslation = sourceWaveRange - ((textureHeight / sourceWaveRange) * [y floatValue]);
        NSLog(@"%f = (%f / %f) * %f", yTranslation, textureHeight, sourceWaveRange, [y floatValue]);
        vertices[x] = ccp(x, yTranslation);
        x++;
    }
    ccDrawPoly(vertices, self.reducedArray.count, NO);
    
    x = 3;
    for (NSNumber *y in self.reducedArray) {
        float yTranslation = sourceWaveRange - ((textureHeight / sourceWaveRange) * [y floatValue]);
        NSLog(@"%f = (%f / %f) * %f", yTranslation, textureHeight, sourceWaveRange, [y floatValue]);
        vertices[x] = ccp(x, yTranslation);
        x++;
    }
    ccDrawPoly(vertices, self.reducedArray.count, NO);
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
}

@end
