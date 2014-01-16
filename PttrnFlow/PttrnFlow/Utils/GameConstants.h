//
//  GameConstants.h
//  SequencerGame
//
//  Created by John Saba on 1/20/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// TODO: maybe just change everything to strings
typedef enum
{
    kDirectionNone = 0,
    kDirectionUp,
    kDirectionRight,
    kDirectionDown,
    kDirectionLeft,
    kDirectionThrough,
} kDirection;

// size
FOUNDATION_EXPORT CGFloat const kSizeGridUnit;
FOUNDATION_EXPORT CGFloat const kStatusBarHeight;

// duration
FOUNDATION_EXPORT ccTime const kTransitionDuration;

// notifications
FOUNDATION_EXPORT NSString *const kNotificationRemoveTickReponder;
FOUNDATION_EXPORT NSString *const kNotificationStartPan;
FOUNDATION_EXPORT NSString *const kNotificationLockPan;
FOUNDATION_EXPORT NSString *const kNotificationUnlockPan;

// frame names
FOUNDATION_EXPORT NSString *const kClearRectUILayer;
FOUNDATION_EXPORT NSString *const kClearRectAudioBatch;

@interface GameConstants : NSObject

@end

