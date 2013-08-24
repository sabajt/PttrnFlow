//
//  AudioTouchDispatcher.h
//  PttrnFlow
//
//  Created by John Saba on 8/24/13.
//
//

#import <Foundation/Foundation.h>

@interface AudioTouchDispatcher : NSObject

- (void)addFragments:(NSArray *)fragments channel:(NSString *)channel;
- (void)sendAudio:(NSString *)channel;

@end
