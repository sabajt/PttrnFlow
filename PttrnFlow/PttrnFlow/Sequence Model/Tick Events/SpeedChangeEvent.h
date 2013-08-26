//
//  SpeedChangeEvent.h
//  PttrnFlow
//
//  Created by John Saba on 8/26/13.
//
//

#import "TickEvent.h"

@interface SpeedChangeEvent : TickEvent

@property (copy, nonatomic) NSString *speed;

- (id)initWithChannel:(NSString *)channel speed:(NSString *)speed;

@end
