//
//  TextureUtils.h
//  SequencerGame
//
//  Created by John Saba on 2/2/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TextureUtils : NSObject

#pragma mark - Sprite sheet keys

FOUNDATION_EXPORT NSString *const kTextureKeySamplePads;
FOUNDATION_EXPORT NSString *const kTextureKeySynthPads;
FOUNDATION_EXPORT NSString *const kTextureKeyOther;
FOUNDATION_EXPORT NSString *const kTextureKeyUILayer;
FOUNDATION_EXPORT NSString *const kTextureKeyBackground;

#pragma mark - Old

FOUNDATION_EXPORT NSString *const kImageNote1;
FOUNDATION_EXPORT NSString *const kImageNote2;
FOUNDATION_EXPORT NSString *const kImageNote3;
FOUNDATION_EXPORT NSString *const kImageNote4;
FOUNDATION_EXPORT NSString *const kImageNote5;
FOUNDATION_EXPORT NSString *const kImageNote6;
FOUNDATION_EXPORT NSString *const kImageNote7;
FOUNDATION_EXPORT NSString *const kImageNote8;
FOUNDATION_EXPORT NSString *const kImageNote9;
FOUNDATION_EXPORT NSString *const kImageNote10;
FOUNDATION_EXPORT NSString *const kImageNote11;
FOUNDATION_EXPORT NSString *const kImageNote12;
FOUNDATION_EXPORT NSString *const kImageNote1on;
FOUNDATION_EXPORT NSString *const kImageNote2on;
FOUNDATION_EXPORT NSString *const kImageNote3on;
FOUNDATION_EXPORT NSString *const kImageNote4on;
FOUNDATION_EXPORT NSString *const kImageNote5on;
FOUNDATION_EXPORT NSString *const kImageNote6on;
FOUNDATION_EXPORT NSString *const kImageNote7on;
FOUNDATION_EXPORT NSString *const kImageNote8on;
FOUNDATION_EXPORT NSString *const kImageNote9on;
FOUNDATION_EXPORT NSString *const kImageNote10on;
FOUNDATION_EXPORT NSString *const kImageNote11on;
FOUNDATION_EXPORT NSString *const kImageNote12on;


// define image names
//FOUNDATION_EXPORT NSString *const kImageA_on;
//FOUNDATION_EXPORT NSString *const kImageA;
//FOUNDATION_EXPORT NSString *const kImageA_flat_on;
//FOUNDATION_EXPORT NSString *const kImageA_flat;
//FOUNDATION_EXPORT NSString *const kImageB_on;
//FOUNDATION_EXPORT NSString *const kImageB;
//FOUNDATION_EXPORT NSString *const kImageB_flat_on;
//FOUNDATION_EXPORT NSString *const kImageB_flat;
//FOUNDATION_EXPORT NSString *const kImageBlank_on;
//FOUNDATION_EXPORT NSString *const kImageBlank;
//FOUNDATION_EXPORT NSString *const kImageC_on;
//FOUNDATION_EXPORT NSString *const kImageC;
//FOUNDATION_EXPORT NSString *const kImageC_sharp_on;
//FOUNDATION_EXPORT NSString *const kImageC_sharp;
//FOUNDATION_EXPORT NSString *const kImageD_on;
//FOUNDATION_EXPORT NSString *const kImageD;
//FOUNDATION_EXPORT NSString *const kImageE_on;
//FOUNDATION_EXPORT NSString *const kImageE;
//FOUNDATION_EXPORT NSString *const kImageE_flat_on;
//FOUNDATION_EXPORT NSString *const kImageE_flat;
//FOUNDATION_EXPORT NSString *const kImageF_on;
//FOUNDATION_EXPORT NSString *const kImageF;
//FOUNDATION_EXPORT NSString *const kImageF_sharp_on;
//FOUNDATION_EXPORT NSString *const kImageF_sharp;
//FOUNDATION_EXPORT NSString *const kImageG_on;
//FOUNDATION_EXPORT NSString *const kImageG;

FOUNDATION_EXPORT NSString *const kImageStartArrow;

//FOUNDATION_EXPORT NSString *const kImageDrum1;
//FOUNDATION_EXPORT NSString *const kImageDrum1_on;
//FOUNDATION_EXPORT NSString *const kImageDrum2;
//FOUNDATION_EXPORT NSString *const kImageDrum2_on;
//FOUNDATION_EXPORT NSString *const kImageDrum3;
//FOUNDATION_EXPORT NSString *const kImageDrum3_on;
//FOUNDATION_EXPORT NSString *const kImageDrum4;
//FOUNDATION_EXPORT NSString *const kImageDrum4_on;

FOUNDATION_EXPORT NSString *const kImageArrowDown;
FOUNDATION_EXPORT NSString *const kImageArrowLeft;
FOUNDATION_EXPORT NSString *const kImageArrowRight;
FOUNDATION_EXPORT NSString *const kImageArrowUp;

FOUNDATION_EXPORT NSString *const kImageWarpDefault;
FOUNDATION_EXPORT NSString *const kImageWarpConnected;

FOUNDATION_EXPORT NSString *const kImageArrowButton_off;
FOUNDATION_EXPORT NSString *const kImageArrowButton_on;
FOUNDATION_EXPORT NSString *const kImageWarpButton_off;
FOUNDATION_EXPORT NSString *const kImageWarpButton_on;

FOUNDATION_EXPORT NSString *const kImageAudioPad;
FOUNDATION_EXPORT NSString *const kImageSpeedDouble;
FOUNDATION_EXPORT NSString *const kImageAudioStop;
FOUNDATION_EXPORT NSString *const kImageItemButtonAudioStopOff;
FOUNDATION_EXPORT NSString *const kImageItemButtonAudioStopOn;
FOUNDATION_EXPORT NSString *const kImageItemButtonSpeedDoubleOff;
FOUNDATION_EXPORT NSString *const kImageItemButtonSpeedDoubleOn;


+ (void)loadTextures;

// generate a unique texture key using components of primative image size and color
+ (NSString *)keyForPrimativeWithSize:(CGSize)size color:(ccColor3B)color;

@end
