//
//  PFLMultiSample.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "PFLMultiSample.h"

@implementation PFLMultiSample

- (id)initWithSamples:(NSArray *)samples
{
    self = [super init];
    if (self) {
        self.samples = samples;
    }
    return self;
}

@end
