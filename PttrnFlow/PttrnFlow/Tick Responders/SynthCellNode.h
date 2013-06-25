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

@end
