//
//  TextureUtils.m
//  Sequencer Game
//
//  Created by John Saba on 2/2/13.
//
//

#import "TextureUtils.h"

@implementation TextureUtils

#pragma mark - Sprite sheet keyse

NSString *const kTextureKeySamplePads = @"samplePads";

#pragma mark - Old images

NSString *const kImageNote1 = @"note-1.png";
NSString *const kImageNote2 = @"note-2.png";
NSString *const kImageNote3 = @"note-3.png";
NSString *const kImageNote4 = @"note-4.png";
NSString *const kImageNote5 = @"note-5.png";
NSString *const kImageNote6 = @"note-6.png";
NSString *const kImageNote7 = @"note-7.png";
NSString *const kImageNote8 = @"note-8.png";
NSString *const kImageNote9 = @"note-9.png";
NSString *const kImageNote10 = @"note-10.png";
NSString *const kImageNote11 = @"note-11.png";
NSString *const kImageNote12 = @"note-12.png";
NSString *const kImageNote1on = @"note-1-on.png";
NSString *const kImageNote2on = @"note-2-on.png";
NSString *const kImageNote3on = @"note-3-on.png";
NSString *const kImageNote4on = @"note-4-on.png";
NSString *const kImageNote5on = @"note-5-on.png";
NSString *const kImageNote6on = @"note-6-on.png";
NSString *const kImageNote7on = @"note-7-on.png";
NSString *const kImageNote8on = @"note-8-on.png";
NSString *const kImageNote9on = @"note-9-on.png";
NSString *const kImageNote10on = @"note-10-on.png";
NSString *const kImageNote11on = @"note-11-on.png";
NSString *const kImageNote12on = @"note-12-on.png";

//NSString *const kImageA_on = @"A-on.png";
//NSString *const kImageA = @"A.png";
//NSString *const kImageA_flat_on = @"Aflat-on.png";
//NSString *const kImageA_flat = @"Aflat.png";
//NSString *const kImageB_on = @"B-on.png";
//NSString *const kImageB = @"B.png";
//NSString *const kImageB_flat_on = @"Bflat-on.png";
//NSString *const kImageB_flat = @"Bflat.png";
//NSString *const kImageBlank_on = @"blank-on.png";
//NSString *const kImageBlank = @"blank.png";
//NSString *const kImageC_on = @"C-on.png";
//NSString *const kImageC = @"C.png";
//NSString *const kImageC_sharp_on = @"Csharp-on.png";
//NSString *const kImageC_sharp = @"Csharp.png";
//NSString *const kImageD_on = @"D-on.png";
//NSString *const kImageD = @"D.png";
//NSString *const kImageE_on = @"E-on.png";
//NSString *const kImageE = @"E.png";
//NSString *const kImageE_flat_on = @"Eflat-on.png";
//NSString *const kImageE_flat = @"Eflat.png";
//NSString *const kImageF_on = @"F-on.png";
//NSString *const kImageF = @"F.png";
//NSString *const kImageF_sharp_on = @"Fsharp-on.png";
//NSString *const kImageF_sharp = @"Fsharp.png";
//NSString *const kImageG_on = @"G-on.png";
//NSString *const kImageG = @"G.png";

NSString *const kImageStartArrow = @"startArrow.png";

//NSString *const kImageDrum1 = @"drum1.png";
//NSString *const kImageDrum1_on = @"drum1on.png";
//NSString *const kImageDrum2 = @"drum2.png";
//NSString *const kImageDrum2_on = @"drum2on.png";
//NSString *const kImageDrum3 = @"drum3.png";
//NSString *const kImageDrum3_on = @"drum3on.png";
//NSString *const kImageDrum4 = @"drum4.png";
//NSString *const kImageDrum4_on = @"drum4on.png";

NSString *const kImageArrowDown = @"arrow-down.png";
NSString *const kImageArrowLeft = @"arrow-left.png";
NSString *const kImageArrowRight = @"arrow-right.png";
NSString *const kImageArrowUp = @"arrow-up.png";
NSString *const kImageWarpDefault = @"warp.png";
NSString *const kImageWarpConnected = @"warpConnected.png";

NSString *const kImageArrowButton_off = @"itemButtonArrowOff.png";
NSString *const kImageArrowButton_on = @"itemButtonArrowOn.png";
NSString *const kImageWarpButton_off = @"itemButtonWarpOff.png";
NSString *const kImageWarpButton_on = @"itemButtonWarpOn.png";

NSString *const kImageAudioPad= @"audio-pad.png";
NSString *const kImageSpeedDouble = @"speed-double.png";
NSString *const kImageAudioStop = @"audio-stop.png";

NSString *const kImageItemButtonAudioStopOff = @"itemButtonAudioStopOff.png";
NSString *const kImageItemButtonAudioStopOn = @"itemButtonAudioStopOn.png";
NSString *const kImageItemButtonSpeedDoubleOff = @"itemButtonSpeedDoubleOff.png";
NSString *const kImageItemButtonSpeedDoubleOn = @"itemButtonSpeedDoubleOn.png";

// don't forget to load the images
+ (void)loadTextures
{        
//    [[CCTextureCache sharedTextureCache] addImage:kImageA_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageA];
//    [[CCTextureCache sharedTextureCache] addImage:kImageA_flat_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageA_flat];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowDown];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowLeft];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowRight];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowUp];
//    [[CCTextureCache sharedTextureCache] addImage:kImageB_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageB];
//    [[CCTextureCache sharedTextureCache] addImage:kImageB_flat_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageB_flat];
//    [[CCTextureCache sharedTextureCache] addImage:kImageBlank_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageBlank];
//    [[CCTextureCache sharedTextureCache] addImage:kImageC_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageC];
//    [[CCTextureCache sharedTextureCache] addImage:kImageC_sharp_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageC_sharp];
//    [[CCTextureCache sharedTextureCache] addImage:kImageD_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageD];
//    [[CCTextureCache sharedTextureCache] addImage:kImageE_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageE];
//    [[CCTextureCache sharedTextureCache] addImage:kImageE_flat_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageE_flat];
//    [[CCTextureCache sharedTextureCache] addImage:kImageF_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageF];
//    [[CCTextureCache sharedTextureCache] addImage:kImageF_sharp_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageF_sharp];
//    [[CCTextureCache sharedTextureCache] addImage:kImageG_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageG];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageStartArrow];

//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum1];
//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum1_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum2];
//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum2_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum3];
//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum3_on];
//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum4];
//    [[CCTextureCache sharedTextureCache] addImage:kImageDrum4_on];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowButton_off];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowButton_on];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageWarpDefault];
    [[CCTextureCache sharedTextureCache] addImage:kImageWarpButton_off];
    [[CCTextureCache sharedTextureCache] addImage:kImageWarpButton_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageAudioPad];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageNote1];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote2];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote3];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote4];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote5];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote6];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote7];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote8];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote9];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote10];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote11];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote12];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageNote1on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote2on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote3on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote4on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote5on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote6on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote7on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote8on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote9on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote10on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote11on];
    [[CCTextureCache sharedTextureCache] addImage:kImageNote12on];

    [[CCTextureCache sharedTextureCache] addImage:kImageSpeedDouble];
    [[CCTextureCache sharedTextureCache] addImage:kImageAudioStop];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageItemButtonAudioStopOff];
    [[CCTextureCache sharedTextureCache] addImage:kImageItemButtonAudioStopOn];
    [[CCTextureCache sharedTextureCache] addImage:kImageItemButtonSpeedDoubleOff];
    [[CCTextureCache sharedTextureCache] addImage:kImageItemButtonSpeedDoubleOn];
}

// generate a unique texture key using components of primative image size and color
+ (NSString *)keyForPrimativeWithSize:(CGSize)size color:(ccColor3B)color
{
    return [NSString stringWithFormat:@"%i%i%i%i%i", (int)size.width, (int)size.height, color.r, color.b, color.g];
}




@end
