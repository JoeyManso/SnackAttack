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

@class EAGLView;
@class BaseView;

@interface ViewManager : UIView 
{	
	// Grab the bounds of the screen
	CGRect screenBounds;
	
	NSMutableDictionary *appViews;
	BaseView *currentView;
}
+(ViewManager*)getInstance;
-(void)showMainMenu;
-(void)showMainMenuDeactivateResume;
-(void)showMainMenuNoIgnore;
-(void)showInstructions;
-(void)showCredits;
-(void)newGame;
-(void)resumeGame;

-(void)drawCurrentView;
-(void)updateCurrentView:(float)deltaTime;
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;

@end
