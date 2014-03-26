//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "SequenceMenuLayer.h"
#import "PuzzleLayer.h"
#import "PFLPuzzle.h"
#import "AudioTouchDispatcher.h"
#import "PFLPuzzleSet.h"
#import "PFLTransitionSlide.h"

@interface SequenceMenuLayer ()

@property (strong, nonatomic) PFLPuzzleSet *puzzleSet;

@end

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
        self.puzzleSet = [PFLPuzzleSet puzzleSetFromResource:@"puzzleSet0"];
        
        // create and layout cells
        CGSize sideMargins = CGSizeMake(50, 50);
        CGSize padding = CGSizeMake(20, 20);
        int i = 0;
        for (PFLPuzzle *puzzle in self.puzzleSet.puzzles) {
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
    CCScene *scene = [PuzzleLayer sceneWithPuzzle:self.puzzleSet.puzzles[index]];
    id transitionScene = [[PFLTransitionSlide alloc] initWithDuration:1.0f scene:scene forwards:YES leftPadding:0.0f rightPadding:0.0f];
    [[CCDirector sharedDirector] pushScene:transitionScene];
}

@end
