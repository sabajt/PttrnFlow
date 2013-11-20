//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "SequenceMenuLayer.h"
#import "PathUtils.h"
#import "SequenceLayer.h"

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
        // map names from .tmx files
        _mapNames = [PathUtils puzzleFileNames];
         
        // create and layout cells
        CGSize sideMargins = CGSizeMake(50, 50);
        CGSize padding = CGSizeMake(20, 20);
        int i = 0;
        for (NSString *name in _mapNames) {
            SequenceMenuCell *cell = [[SequenceMenuCell alloc] initWithIndex:i];
            CGFloat yPosition = sideMargins.height + ((i * cell.contentSize.height) + (i * padding.height));
            cell.position = ccp(sideMargins.width, yPosition);
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
    [[CCDirector sharedDirector] pushScene:[SequenceLayer sceneWithSequence:index]];
}


@end
