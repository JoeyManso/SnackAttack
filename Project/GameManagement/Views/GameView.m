//
//  AppViews.m
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameView.h"

@interface GameView()

@end


@implementation GameView

-(id)init
{
	if(self = [super init])
	{
		touchManager = [TouchManager getInstance];
		UIMan = [UIManager getInstance];
		
		// initialize Map
		map = [[Map1 alloc] init];
		[touchManager setMap:map];
		[[GameState sharedGameStateInstance] setMap:map];
	}
	return self;
}

-(void)updateView:(float)deltaTime
{
	[map update:deltaTime];
	
	// update any UI
	[UIMan updateActiveUI:deltaTime];
}

-(void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	UITouch* t = [touches anyObject];
	CGPoint touchPosition = [t locationInView:view];
	// for some reason, OpenGL coordinates are reversed vertically from the touch events, so we have to do this
	touchPosition.y = screenBounds.size.height - touchPosition.y;
	
	// first check for a UI event, and if none, check for an in game touch event.
	if(![UIMan touchEvent:touchPosition] && ![UIMan showingMessageScreen])
		[touchManager selectObjectAtPosition:touchPosition];
}
-(void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	UITouch* t = [touches anyObject];
	CGPoint touchPosition = [t locationInView:view];
	touchPosition.y = screenBounds.size.height - touchPosition.y;
	if(![UIMan showingMessageScreen])
		[touchManager moveObjectToPosition:touchPosition];
}
-(void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	[touchManager unselectObject];
}

-(void)drawView
{	
	[map draw];
	
	// draw active UI
	[UIMan drawActiveUI];
}

@end
