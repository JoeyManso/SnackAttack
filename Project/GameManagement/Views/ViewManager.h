//
//  ViewManager.h
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class BaseView;
@class EAGLView;

@interface ViewManager : UIView 
{	
	// Grab the bounds of the screen
	CGRect screenBounds;
    CGFloat screenScale;
    CGSize screenSize;
	
	NSMutableDictionary *appViews;
	BaseView *currentView;
    EAGLView *rootView;
}

@property(nonatomic, readonly)CGRect screenBounds;
@property(nonatomic, readonly)CGFloat screenScale;
@property(nonatomic, readonly)CGSize screenSize;

+(ViewManager*)getInstance;
-(void)postInit:(EAGLView*)inRootView;
-(void)showMainMenu;
-(void)showMainMenuNoIgnore;
-(void)setResumeEnabled:(BOOL)enabled;
-(void)setLeaderboardEnabled:(BOOL)enabled;
-(void)showSelectMap;
-(void)showGCAuthenticate:(UIViewController*)gcViewController;
-(void)showLeaderboard;
-(void)showInstructions;
-(void)showCredits;
-(int)getMapIdx;
-(void)setGameMapIdx:(int)mapIdx;
-(void)newGame;
-(void)resumeGame;
-(UIViewController*)getRootViewController;

-(void)drawCurrentView;
-(void)updateCurrentView:(float)deltaTime;
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;

@end
