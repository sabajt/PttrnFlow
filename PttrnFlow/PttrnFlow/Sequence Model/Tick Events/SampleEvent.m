//
//  SampleEvent.m
//  PttrnFlow
//
//  Created by John Saba on 8/18/13.
//
//

#import "SampleEvent.h"

@implementation SampleEvent

- (id)initWithAudioID:(NSNumber *)audioID sampleName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.audioID = audioID;
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

#pragma mark - Subclass hooks

- (BOOL)isEqualToEvent:(TickEvent *)event
{
    if (![event isKindOfClass:self.class]) {
        return NO;
    }
    SampleEvent *sampleEvent = (SampleEvent *)event;
    return ([sampleEvent.fileName isEqualToString:self.fileName]);
}

- (NSString *)eventDescription
{
    return [NSString stringWithFormat:@"%@ : { sample file : %@ } { audio ID : %@ }", self, self.fileName, self.audioID];
}

@end
