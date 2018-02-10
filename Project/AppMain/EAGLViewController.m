/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This UIViewController configures the OpenGL ES view and its UI when an external display is connected/disconnected.
 */

#import "EAGLViewController.h"
#import "EAGLView.h"

@implementation EAGLViewController

- (void)screenDidConnect:(UIViewController *)userInterface
{
    // Remove UI previously added atop the GL view
    for (UIView* v in [self.view subviews])
        [v removeFromSuperview];
    
    // One of these userInterface view controllers is visible at a time,
    // so release the other one to minimize memory usage
    /*self.userInterfaceOnTop = nil;
    self.userInterfaceFullscreen = userInterface;
    
    if (self.userInterfaceFullscreen)
    {
        // Setup UI (When an external display is connected, it will be added to mainViewController's view
        // in MainViewController/-screenDidChange:)
        [(UserInterfaceViewController *)self.userInterfaceFullscreen screenDidConnect];
        
        // Set the userControlDelegte, which is responsible for setting the cube's rotating radius
        [(GLView *)self.view setUserControlDelegate:(id)self.userInterfaceFullscreen];
    }*/
}

- (void)screenDidDisconnect:(UIViewController *)userInterface
{
    // One of these userInterface view controllers is visible at a time,
    // so release the other one to minimize memory usage
    /*self.userInterfaceFullscreen = nil;
    self.userInterfaceOnTop = userInterface;
    
    if (self.userInterfaceOnTop)
    {
        // Setup UI
        [(UserInterfaceViewController *)self.userInterfaceOnTop screenDidDisconnect];
        
        // Add UI on top
        [(GLView *)self.view addSubview:self.userInterfaceOnTop.view];
        
        // Set the userControlDelegte, which is responsible for setting the cube's rotating radius
        [(GLView *)self.view setUserControlDelegate:(id)self.userInterfaceOnTop];
    }*/
}

- (void)setTargetScreen:(UIScreen *)targetScreen
{
    // Delegate to the GL view to create a CADisplayLink for the target display (UIScreen/-displayLinkWithTarget:selector:)
    // This will result in the native fps for whatever display you create it from.
    //[(GLView *)self.view setTargetScreen:targetScreen];
}

- (void)startAnimation
{
   // [(GLView *)self.view startAnimation];
}

- (void)stopAnimation
{
   // [(GLView *)self.view stopAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)showLeaderboard
{
    // Present default leaderboard
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if(gameCenterController)
    {
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeAllTime;
        gameCenterController.leaderboardIdentifier = @"Leaderboard_01";
        gameCenterController.gameCenterDelegate = self;
        [self presentViewController:gameCenterController animated:YES completion:nil];
    }
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
};

@end
