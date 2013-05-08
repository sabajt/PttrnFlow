//
//  GameConstants.m
//  SequencerGame
//
//  Created by John Saba on 1/20/13.
//
//

#import "GameConstants.h"

CGFloat const kSizeGridUnit = 200;

@implementation GameConstants

+(CGSize)landscapeScreenSize
{
    CGSize portrait = [UIScreen mainScreen].bounds.size;
    return CGSizeMake(portrait.height, portrait.width);
}

@end