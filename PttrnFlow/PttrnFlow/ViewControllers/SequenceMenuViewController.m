//
//  SequenceMenuViewController.m
//  SequencerGame
//
//  Created by John Saba on 4/27/13.
//
//

#import "SequenceMenuViewController.h"
#import "PathUtils.h"
#import "SequenceMenuCell.h"

@implementation SequenceMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[SequenceMenuCell class] forCellWithReuseIdentifier:@"SequenceMenuCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [PathUtils tileMapNames].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SequenceMenuCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SequenceMenuCell" forIndexPath:indexPath];
    [cell configureWithIndexPath:indexPath];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SequenceViewController *sequenceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sequence"];
    sequenceViewController.sequence = indexPath.row;
    sequenceViewController.delegate = self;
    
    [self presentViewController:sequenceViewController animated:YES completion:nil];
}

#pragma mark - SequenceViewControllerDelegate

- (void)pressedBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        // completion
    }];
}

@end
