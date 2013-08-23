//
//  DirectionEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "TickEvent.h"

@interface DirectionEvent : TickEvent

@property (copy, nonatomic) NSString *direction;

- (id)initWithChannel:(int)channel direction:(NSString *)direction;

@end
