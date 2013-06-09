//
//  SequenceMenuCell.m
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "SequenceMenuCell.h"

@implementation SequenceMenuCell

- (void)configureWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.levelLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.levelLabel = label;
        [self addSubview:self.levelLabel];
    }
    self.levelLabel.text = [NSString stringWithFormat:@"%i", indexPath.row + 1];
}

@end
