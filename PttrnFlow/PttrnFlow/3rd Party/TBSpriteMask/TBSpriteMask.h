//
//  TBSpriteMask.h
//  ShaderMask
//
//  Created by Tony BELTRAMELLI on 26/01/13.
//
//

#import "cocos2d.h"

@interface TBSpriteMask : CCSprite
{
    CCSprite*  _mask;
    CCTexture2D* _maskTexture;
    GLuint _textureLocation;
    GLuint _maskLocation;
    BOOL _type;
}

-(id)initWithSprite:(CCSprite*)sprite andMaskSprite:(CCSprite*)maskSprite;
-(id)initWithSprite:(CCSprite*)sprite andMaskFile:(NSString*)maskFile;
-(id)initWithFile:(NSString *)file andMaskFile:(NSString*)maskFile;
-(id)initWithFile:(NSString *)file andMaskSprite:(CCSprite*)maskSprite;

-(id)initWithSprite:(CCSprite*)sprite andMaskSprite:(CCSprite*)maskSprite andType:(BOOL)type;
-(id)initWithSprite:(CCSprite*)sprite andMaskFile:(NSString*)maskFile andType:(BOOL)type;
-(id)initWithFile:(NSString *)file andMaskFile:(NSString*)maskFile andType:(BOOL)type;
-(id)initWithFile:(NSString *)file andMaskSprite:(CCSprite*)maskSprite andType:(BOOL)type;

-(void)updateWithSprite:(CCSprite*)sprite;
-(void)updateWithFile:(NSString *)file;

-(CCTexture2D *)getTexture;

@end
