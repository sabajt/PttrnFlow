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
#import "PFLAudioResponderTouchController.h"
#import "PFLPuzzleSet.h"
#import "PFLTransitionSlide.h"
#import "PFLPuzzleBackgroundLayer.h"

@interface PFLPuzzleSetLayer ()

@property (strong, nonatomic) PFLPuzzleSet *puzzleSet;

@end

@implementation PFLPuzzleSetLayer

+ (CCScene *)sceneWithPuzzleSet:(PFLPuzzleSet *)puzzleSet leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding
{
    CCScene *scene = [CCScene node];
    
    // background
    PFLPuzzleBackgroundLayer *background = [PFLPuzzleBackgroundLayer backgroundLayerWithTheme:puzzleSet.theme];
    background.contentSize = CGSizeMake(background.contentSize.width + leftPadding + rightPadding, background.contentSize.height);
    background.position = ccpSub(background.position, ccp(leftPadding, 0.0f));
    [scene addChild:background];
    
    PFLPuzzleSetLayer *menuLayer = [[PFLPuzzleSetLayer alloc] initWithPuzzleSet:puzzleSet];
    [scene addChild:menuLayer];
    return scene;
}

- (id)initWithPuzzleSet:(PFLPuzzleSet *)puzzleSet
{
    self = [super init];
    if (self) {
        self.puzzleSet = puzzleSet;
        self.allowsScrollHorizontal = NO;
        
        // create and layout cells
        CGSize sideMargins = CGSizeMake(50, 50);
        CGSize padding = CGSizeMake(20, 20);
        int i = 0;
        for (PFLPuzzle *puzzle in self.puzzleSet.puzzles) {
            PFLPuzzleSetCell *cell = [[PFLPuzzleSetCell alloc] initWithIndex:i];
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

- (void)puzzleSetCellTouchUpInside:(PFLPuzzleSetCell *)cell index:(NSInteger)index
{
    CCScene *scene = [PFLPuzzleLayer sceneWithPuzzle:self.puzzleSet.puzzles[index] leftPadding:0.0f rightPadding:0];
    id transitionScene = [[PFLTransitionSlide alloc] initWithDuration:0.33f scene:scene above:NO forwards:YES leftPadding:0.0f rightPadding:0.0f];
    [[CCDirector sharedDirector] replaceScene:transitionScene];
}

@end
