//
//  SequenceItemLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/29/13.
//
//

#import "CCLayer.h"


FOUNDATION_EXPORT NSString *const kSequenceItemArrow;
FOUNDATION_EXPORT NSString *const kSequenceItemWarp;
FOUNDATION_EXPORT NSString *const kSequenceItemSplitter;


@interface SequenceItemLayer : CCLayerColor

+ (id)layerWithColor:(ccColor4B)color width:(GLfloat)w items:(NSArray *)items;

@end
