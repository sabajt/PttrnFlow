//
//  GameSprite.h
//  PttrnFlow
//
//  Created by John Saba on 9/14/13.
//
//

#import "cocos2d.h"
#import "GridUtils.h"
#import "TouchSprite.h"

@interface GameSprite : TouchSprite

@property (assign) GridCoord cell;
@property (assign) CGSize cellSize;

@property (copy, nonatomic) NSString *decaySpeed;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName cell:(GridCoord)cell;

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan;

@end