//
//  SequenceMenuLayer.m
//  PttrnFlow
//
//  Created by John Saba on 6/12/13.
//
//

#import "SequenceMenuLayer.h"
#import "SequenceMenuCell.h"
#import "PathUtils.h"

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
        _mapNames = [PathUtils tileMapNames];
         
        // create and layout cells
        CGSize sideMargins = CGSizeMake(50, 50);
        CGSize padding = CGSizeMake(20, 20);
        int i = 0;
        for (NSString *name in _mapNames) {
            SequenceMenuCell *cell = [[SequenceMenuCell alloc] initWithIndex:i];
            CGFloat yPosition = sideMargins.height + ((i * cell.contentSize.height) + (i * padding.height));
            cell.position = ccp(sideMargins.width, yPosition);
            [self addChild:cell];
            i++;
        }
    }
    return self;
}


@end
