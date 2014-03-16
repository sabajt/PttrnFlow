//
//  PFLKeyframe.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLKeyframe.h"

NSString *const kPFLKeyframeRange = @"range";
NSString *const kPFLKeyframeSourceIndex = @"source_index";
NSString *const kPFLKeyframeTargetIndex = @"target_index";

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
        self.range = [object[kPFLKeyframeRange] integerValue];
        self.sourceIndex = [object[kPFLKeyframeSourceIndex] integerValue];
        self.targetIndex = [object[kPFLKeyframeTargetIndex] integerValue];
    }
    return self;
}

@end
