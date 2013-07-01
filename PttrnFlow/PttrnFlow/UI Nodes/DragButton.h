//
//  DragButton.h
//  PttrnFlow
//
//  Created by John Saba on 7/1/13.
//
//

#import "TouchNode.h"

@interface DragButton : TouchNode

+ (DragButton *)buttonWithDefaultImage:(NSString *)defaultName selectedImage:(NSString *)selectedName dragItem:(CCSprite *)item;

@end
