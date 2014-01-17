//
//  TileSprite.h
//  PttrnFlow
//
//  Created by John Saba on 11/3/13.
//
//

#import "CCSprite.h"

@interface TileSprite : CCSprite

- (id)initWithTileFrameName:(NSString *)name placeholderFrameName:(NSString *)placeholderName repeatHorizonal:(int)repeatHorizontal repeatVertical:(int)repeatVertical;
- (id)initWithTileFrameName:(NSString *)name placeholderFrameName:(NSString *)placeholderName repeatHorizonal:(int)repeatHorizontal repeatVertical:(int)repeatVertical skip:(NSInteger)skip;

@end
