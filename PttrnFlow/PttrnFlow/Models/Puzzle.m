//
//  Puzzle.m
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import "Puzzle.h"

@implementation Puzzle

+ (Puzzle *)puzzleFromResource:(NSString *)resource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@".json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSAssert(error == nil, @"Failed to deserialize %@.json with error: %@", resource, error.description);
    return [[Puzzle alloc] initWithJson:json];
}

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.name = json[@"name"];
        self.area = json[@"area"];
        self.audio = json[@"audio"];
        self.glyphs = json[@"glyphs"];
        self.solution = json[@"solution"];
    }
    return self;
}

@end
