//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "PFLPuzzleSetLayer.h"
#import "PFLPuzzleLayer.h"
#import "PFLPuzzle.h"
#import "PFLAudioTouchController.h"
#import "PFLPuzzleSet.h"
#import "PFLTransitionSlide.h"

@interface PFLPuzzleSetLayer ()

@property (strong, nonatomic) PFLPuzzleSet *puzzleSet;

@end

@implementation PFLPuzzleSetLayer

+ (CCScene *)scene
{
    CCScene *scene = [CCScene node];
    PFLPuzzleSetLayer *menuLayer = [[PFLPuzzleSetLayer alloc] init];
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
    CCScene *scene = [PFLPuzzleLayer sceneWithPuzzle:self.puzzleSet.puzzles[index] leftPadding:0.0f rightPadding:0];
    id transitionScene = [[PFLTransitionSlide alloc] initWithDuration:0.33f scene:scene forwards:YES leftPadding:0.0f rightPadding:0.0f];
    [[CCDirector sharedDirector] replaceScene:transitionScene];
}

@end
