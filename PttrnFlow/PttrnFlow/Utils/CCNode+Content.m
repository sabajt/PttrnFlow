//
//  CCNode+Content.m
//  PttrnFlow
//
//  Created by John Saba on 6/27/13.
//
//

#import "CCNode+Content.h"

@implementation CCNode (Content)

- (CGPoint)contentCenter
{
    return ccp(self.contentSize.width/2, self.contentSize.height/2);
}

@end
