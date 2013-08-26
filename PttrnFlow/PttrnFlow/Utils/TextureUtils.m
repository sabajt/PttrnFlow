//
//  TextureUtils.m
//  Sequencer Game
//
//  Created by John Saba on 2/2/13.
//
//

#import "TextureUtils.h"

@implementation TextureUtils

NSString *const kImageA_on = @"A-on.png";
NSString *const kImageA = @"A.png";
NSString *const kImageA_flat_on = @"Aflat-on.png";
NSString *const kImageA_flat = @"Aflat.png";
NSString *const kImageB_on = @"B-on.png";
NSString *const kImageB = @"B.png";
NSString *const kImageB_flat_on = @"Bflat-on.png";
NSString *const kImageB_flat = @"Bflat.png";
NSString *const kImageBlank_on = @"blank-on.png";
NSString *const kImageBlank = @"blank.png";
NSString *const kImageC_on = @"C-on.png";
NSString *const kImageC = @"C.png";
NSString *const kImageC_sharp_on = @"Csharp-on.png";
NSString *const kImageC_sharp = @"Csharp.png";
NSString *const kImageD_on = @"D-on.png";
NSString *const kImageD = @"D.png";
NSString *const kImageE_on = @"E-on.png";
NSString *const kImageE = @"E.png";
NSString *const kImageE_flat_on = @"Eflat-on.png";
NSString *const kImageE_flat = @"Eflat.png";
NSString *const kImageF_on = @"F-on.png";
NSString *const kImageF = @"F.png";
NSString *const kImageF_sharp_on = @"Fsharp-on.png";
NSString *const kImageF_sharp = @"Fsharp.png";
NSString *const kImageG_on = @"G-on.png";
NSString *const kImageG = @"G.png";

NSString *const kImageStartArrow = @"startArrow.png";

NSString *const kImageDrum1 = @"drum1.png";
NSString *const kImageDrum1_on = @"drum1on.png";
NSString *const kImageDrum2 = @"drum2.png";
NSString *const kImageDrum2_on = @"drum2on.png";
NSString *const kImageDrum3 = @"drum3.png";
NSString *const kImageDrum3_on = @"drum3on.png";
NSString *const kImageDrum4 = @"drum4.png";
NSString *const kImageDrum4_on = @"drum4on.png";

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



// don't forget to load the images
+ (void)loadTextures
{        
    [[CCTextureCache sharedTextureCache] addImage:kImageA_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageA];
    [[CCTextureCache sharedTextureCache] addImage:kImageA_flat_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageA_flat];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowDown];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowLeft];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowRight];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowUp];
    [[CCTextureCache sharedTextureCache] addImage:kImageB_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageB];
    [[CCTextureCache sharedTextureCache] addImage:kImageB_flat_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageB_flat];
    [[CCTextureCache sharedTextureCache] addImage:kImageBlank_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageBlank];
    [[CCTextureCache sharedTextureCache] addImage:kImageC_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageC];
    [[CCTextureCache sharedTextureCache] addImage:kImageC_sharp_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageC_sharp];
    [[CCTextureCache sharedTextureCache] addImage:kImageD_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageD];
    [[CCTextureCache sharedTextureCache] addImage:kImageE_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageE];
    [[CCTextureCache sharedTextureCache] addImage:kImageE_flat_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageE_flat];
    [[CCTextureCache sharedTextureCache] addImage:kImageF_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageF];
    [[CCTextureCache sharedTextureCache] addImage:kImageF_sharp_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageF_sharp];
    [[CCTextureCache sharedTextureCache] addImage:kImageG_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageG];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageStartArrow];

    [[CCTextureCache sharedTextureCache] addImage:kImageDrum1];
    [[CCTextureCache sharedTextureCache] addImage:kImageDrum1_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageDrum2];
    [[CCTextureCache sharedTextureCache] addImage:kImageDrum2_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageDrum3];
    [[CCTextureCache sharedTextureCache] addImage:kImageDrum3_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageDrum4];
    [[CCTextureCache sharedTextureCache] addImage:kImageDrum4_on];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowButton_off];
    [[CCTextureCache sharedTextureCache] addImage:kImageArrowButton_on];
    
    [[CCTextureCache sharedTextureCache] addImage:kImageWarpDefault];
    [[CCTextureCache sharedTextureCache] addImage:kImageWarpButton_off];
    [[CCTextureCache sharedTextureCache] addImage:kImageWarpButton_on];
    [[CCTextureCache sharedTextureCache] addImage:kImageAudioPad];
}

// generate a unique texture key using components of primative image size and color
+ (NSString *)keyForPrimativeWithSize:(CGSize)size color:(ccColor3B)color
{
    return [NSString stringWithFormat:@"%i%i%i%i%i", (int)size.width, (int)size.height, color.r, color.b, color.g];
}




@end
