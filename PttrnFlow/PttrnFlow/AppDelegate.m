//
//  AppDelegate.m
//  SequencerGame
//
//  Created by John Saba on 1/18/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "SequenceLayer.h"
#import "SimpleAudioEngine.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // pure data audio controller
    _audioController = [[PdAudioController alloc] init];
    if ([self.audioController configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES] != PdAudioOK) {
        NSLog(@"failed to initialize audio components");
    }

    return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ ) {
		[director_ pause];
    }
    self.audioController.active = NO;
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ ) {
		[director_ resume];
    }
    self.audioController.active = YES;
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end

