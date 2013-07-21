//
//  SynthCellNode.h
//  PttrnFlow
//
//  Created by John Saba on 6/21/13.
//
//

#import "CellNode.h"
#import "MainSynth.h"

@interface SynthCellNode : CellNode

@property (weak, nonatomic) id<SoundEventReceiver>synth;

- (id)initWithSynth:(id<SoundEventReceiver>)synth;

// subclasses should override and call super to handle any 'deselection behavior' triggered by pan start
- (void)cancelTouchForPan;

@end
