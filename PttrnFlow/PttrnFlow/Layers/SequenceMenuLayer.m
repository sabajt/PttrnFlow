//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "SequenceMenuLayer.h"
#import "PuzzleLayer.h"
#import "Puzzle.h"
#import "AudioTouchDispatcher.h"

@implementation SequenceMenuLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    SequenceMenuLayer *menuLayer = [[SequenceMenuLayer alloc] init];
    [scene addChild:menuLayer];
    return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        _mapNames = @[@"puzzle0", @"puzzle1", @"puzzle2", @"puzzle3"];
         
        // create and layout cells
        CGSize sideMargins = CGSizeMake(50, 50);
        CGSize padding = CGSizeMake(20, 20);
        int i = 0;
        for (NSString *name in _mapNames) {
            SequenceMenuCell *cell = [[SequenceMenuCell alloc] initWithIndex:i];
            cell.anchorPoint = ccp(0.5, 0.5);
            CGFloat yPosition = sideMargins.height + ((i * cell.contentSize.height) + (i * padding.height));
            cell.position = ccp(self.contentSize.width / 2, yPosition);
            cell.menuCellDelegate = self;
            [self addChild:cell];
            i++;
        }
    };
    return self;
}

#pragma mark SequenceMenuCellDelegate

- (void)sequenceMenuCellTouchUpInside:(SequenceMenuCell *)cell index:(int)index
{
    // TODO: this deserialzes everytime.
    NSString *resource = [NSString stringWithFormat:@"puzzle%i", index];
    Puzzle *puzzle = [Puzzle puzzleFromResource:resource];
    
    [[CCDirector sharedDirector] pushScene:[PuzzleLayer sceneWithPuzzle:puzzle]];
}


@end
