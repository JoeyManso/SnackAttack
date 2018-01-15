//
//  towerDefenseAppDelegate.m
//  towerDefense
//
//  Created by Joey Manso on 7/5/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "towerDefenseAppDelegate.h"
#import "EAGLView.h"
#import "EAGLViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation towerDefenseAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	// Not using any NIB files anymore, we are creating the window and the
    // EAGLView manually.

    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    glView = [[[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
    glViewController = [[EAGLViewController alloc] initWithNibName:nil bundle:nil];
    
    [glViewController setView:glView];
    
    [window setRootViewController:glViewController];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
    
    // Add the glView to the window which has been defined
	//[window addSubview:glView];
	[window makeKeyAndVisible];
    
	// main game loop
    [glView performSelectorOnMainThread:@selector(mainLoop) withObject:nil waitUntilDone:NO];
    
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{
}

-(void)appWillTerminate:(NSNotification*)note
{
}

- (void)dealloc 
{
	[window release];
	[glView release];
	[super dealloc];
}

@end
