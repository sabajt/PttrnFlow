//
//  GameConstants.h
//  SequencerGame
//
//  Created by John Saba on 1/20/13.
//
//

#import <Foundation/Foundation.h>

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

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

FOUNDATION_EXPORT NSString *const kNotificationRemoveTickReponder;
FOUNDATION_EXPORT NSString *const kNotificationStartPan;
FOUNDATION_EXPORT NSString *const kNotificationLockPan;
FOUNDATION_EXPORT NSString *const kNotificationUnlockPan;


@interface GameConstants : NSObject

@end

