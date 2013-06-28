//
//  BackgroundLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/28/13.
//
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(void) tintToColor:(ccColor3B)color duration:(ccTime)duration
{
    CCTintTo *tint = [CCTintTo actionWithDuration:duration red:color.r green:color.g blue:color.b];
    [self runAction:tint];
}

@end
