//
//  GameConstants.h
//  SequencerGame
//
//  Created by John Saba on 1/20/13.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    kDirectionNone = 0,
    kDirectionUp,
    kDirectionRight,
    kDirectionDown,
    kDirectionLeft,
    kDirectionThrough,
} kDirection;

FOUNDATION_EXPORT CGFloat const kSizeGridUnit;

@interface GameConstants : NSObject

+(CGSize)landscapeScreenSize;

@end

