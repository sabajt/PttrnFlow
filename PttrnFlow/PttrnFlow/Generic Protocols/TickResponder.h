//
//  TickResponder.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import <Foundation/Foundation.h>
#import "GridUtils.h"

@protocol TickResponder <NSObject>

- (NSString *)tick:(NSInteger)bpm;
- (void)afterTick:(NSInteger)bpm; // this could also return a value that could trigger more events
- (GridCoord)responderCell;

@end