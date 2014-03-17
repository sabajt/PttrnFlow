//
//  PFLKeyframe.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLKeyframe.h"

static NSString *const kRange = @"range";
static NSString *const kSourceIndex = @"source_index";
static NSString *const kTargetIndex = @"target_index";

@implementation PFLKeyframe

+ (NSArray *)keyframesFromArray:(NSArray *)array
{
    NSMutableArray *keyframes = [NSMutableArray array];
    for (NSDictionary *object in array) {
        [keyframes addObject:[[PFLKeyframe alloc] initWithObject:object]];
    }
    return [NSArray arrayWithArray:keyframes];
}

- (id)initWithObject:(NSDictionary *)object
{
    self = [super init];
    if (self) {
        self.range = [object[kRange] integerValue];
        self.sourceIndex = [object[kSourceIndex] integerValue];
        self.targetIndex = [object[kTargetIndex] integerValue];
    }
    return self;
}

@end
