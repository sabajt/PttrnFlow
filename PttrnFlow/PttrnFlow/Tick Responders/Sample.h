//
//  Sample.h
//  PttrnFlow
//
//  Created by John Saba on 6/22/13.
//
//

#import "AudioResponder.h"

@interface Sample : CCSprite <AudioResponder>

- (id)initWithCell:(GridCoord)cell sampleName:(NSString *)sampleName frameName:(NSString *)frameName;

@end
