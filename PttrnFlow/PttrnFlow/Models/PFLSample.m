//
//  PFLSample.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLSample.h"

static NSString *const kFile = @"file";
static NSString *const kImage = @"image";
static NSString *const kTime = @"time";

@implementation PFLSample

+ (NSArray *)samplesFromArray:(NSArray *)array
{
    NSMutableArray *sampels = [NSMutableArray array];
    for (NSDictionary *object in array) {
        [sampels addObject:[[PFLSample alloc] initWithObject:object]];
    }
    return [NSArray arrayWithArray:sampels];
}

- (id)initWithObject:(NSDictionary *)object
{
    self = [super init];
    if (self) {
        self.file = object[kFile];
        self.image = object[kImage];
        self.time = object[kTime];
    }
    return self;
}

@end
