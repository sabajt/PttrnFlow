//
//  NSObject+AudioResponderUtils.h
//  PttrnFlow
//
//  Created by John Saba on 1/10/14.
//
//

#import <Foundation/Foundation.h>

@class PFLCoord;

@interface NSObject (PFLAudioResponderUtils)

@property (assign) CGFloat beatDuration;

- (NSArray *)responders:(NSArray *)responders atCoord:(PFLCoord *)coord;
- (NSArray *)hitResponders:(NSArray *)responders atCoord:(PFLCoord *)coord;

@end
