//
//  SolutionSequence.h
//  PttrnFlow
//
//  Created by John Saba on 8/19/13.
//
//

#import <Foundation/Foundation.h>

@interface SolutionSequence : NSObject

@property (strong, nonatomic) NSArray *sequence;

- (id)initWithSolution:(NSString *)solution;
- (BOOL)tick:(int)tick doesMatchAudioEventsInGroup:(NSArray *)events;

@end
