/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This UIViewController configures the OpenGL ES view and its UI when an external display is connected/disconnected.
 */

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface EAGLViewController : UIViewController <GKGameCenterControllerDelegate>

- (void)startAnimation;
- (void)stopAnimation;
- (void)screenDidConnect:(UIViewController *)userInterface;
- (void)screenDidDisconnect:(UIViewController *)userInterface;
- (void)setTargetScreen:(UIScreen *)targetScreen;
- (void)showLeaderboard;
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)viewController;

@end
