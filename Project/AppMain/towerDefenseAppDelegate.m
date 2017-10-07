//
//  towerDefenseAppDelegate.m
//  towerDefense
//
//  Created by Joey Manso on 7/5/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "towerDefenseAppDelegate.h"
#import "EAGLView.h"

@implementation towerDefenseAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	// Not using any NIB files anymore, we are creating the window and the
    // EAGLView manually.
	if(!window)
		window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];

	glView = [[[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
	
    // Add the glView to the window which has been defined
	[window addSubview:glView];
	[window makeKeyAndVisible];
    
	// main game loop
    [glView performSelectorOnMainThread:@selector(mainLoop) withObject:nil waitUntilDone:NO]; 
}


- (void)applicationWillResignActive:(UIApplication *)application 
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{
}

- (void)dealloc 
{
	[window release];
	[glView release];
	[super dealloc];
}

@end
