//
//  AppViews.m
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameView.h"
#import "TouchManager.h"
#import "UIManager.h"
#import "Map1.h"
#import "Map2.h"
#import "Map3.h"

@interface GameView()

@end


@implementation GameView

@synthesize currentMapIdx;

-(id)init
{
	if(self = [super init])
	{
		touchManager = [TouchManager getInstance];
		UIMan = [UIManager getInstance];
		
		// initialize Maps
        maps = [[NSMutableArray alloc] initWithObjects:
                     [[Map1 alloc] init],
                     [[Map2 alloc] init],
                     [[Map3 alloc] init], nil];
		
		
	}
	return self;
}

-(void)setMapIdx:(int)idx
{
    if(idx >= 0 && idx < maps.count)
    {
        currentMapIdx = idx;
        Map* map = maps[currentMapIdx];
        [touchManager setMap:map];
        [[GameState sharedGameStateInstance] setMap:map];
    }
}

-(void)updateView:(float)deltaTime
{
    float gameSpeed = [[GameState sharedGameStateInstance] gameSpeed];
    Map* map = maps[currentMapIdx];
	[map update:deltaTime * gameSpeed];
	
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
    Map* map = maps[currentMapIdx];
	[map draw];
	
	// draw active UI
	[UIMan drawActiveUI];
}

-(void)dealloc
{
    for(Map* m in maps)
        [m release];
    [maps release];
    [super dealloc];
}

@end
