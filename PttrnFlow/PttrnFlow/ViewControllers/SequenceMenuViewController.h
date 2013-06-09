//
//  SequenceMenuViewController.h
//  PipeGame
//
//  Created by John Saba on 4/27/13.
//
//

#import <UIKit/UIKit.h>
#import "SequenceViewController.h"

@interface SequenceMenuViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SequenceViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
