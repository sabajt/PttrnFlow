//
//  SampleEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "SampleEvent.h"

@implementation SampleEvent

- (id)initWithChannel:(NSString *)channel sampleName:(NSString *)name
{
    self = [super initWithChannel:channel isAudioEvent:YES isLinkedEvent:YES lastLinkedEvent:nil fragments:@[name]];
    if (self) {
        NSAssert([SampleEvent isSampleName:name], @"'%@' is not a valid sample name", name);
        _fileName = name;
    }
    return self;
}

#pragma mark - Value checks

+ (BOOL)isSampleName:(NSString *)sampleName
{
    static NSString *kWav = @"wav";
    if (sampleName.length < (kWav.length + 2)) {
        return NO;
    }
    NSString *extension = [[sampleName componentsSeparatedByString:@"."] lastObject];
    return ([extension isEqualToString:kWav]);
}

@end
