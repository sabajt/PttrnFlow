//
//  SequenceItemLayer.h
//  PttrnFlow
//
//  Created by John Saba on 6/29/13.
//
//

#import "CCLayer.h"
#import "DragButton.h"

@interface SequenceItemLayer : CCLayerColor

+ (id)layerWithBatchNode:(CCSpriteBatchNode *)batchNode color:(ccColor4B)color width:(GLfloat)w items:(NSArray *)items dragButtonDelegate:(id<DragItemDelegate>)delegate;

@end
