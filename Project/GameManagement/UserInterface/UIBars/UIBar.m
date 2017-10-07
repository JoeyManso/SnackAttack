//
//  UIBar.m
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIBar.h"
#import "UIObject.h"
#import "Math.h"

@implementation UIBar

@synthesize currentPosition;
@synthesize displayPosition;
@synthesize hidePosition;
@synthesize state;
@synthesize visible;
@synthesize backgroundWidth;
@synthesize backgroundHeight;
@synthesize buttonPressed;

float const DEFAULT_BACKGROUND_WIDTH = 320.0f;
float const DEFAULT_BACKGROUND_HEIGHT = 50.0f;
float const DEFAULT_TRANSITION_SPEED = 90.0f;

-(id)initWithBackground:(Image*)i
{
	// don't call this!!
	return nil;
}
-(id)initWithDisplayPos:(Point2D*)dispP hidePos:(Point2D*)hideP imageRef:(Image*)i
{
	if(self = [super init])
	{
		displayPosition = dispP;
		hidePosition = hideP;
		background = i;
		// default current position is same as hide position
		currentPosition = [[Point2D alloc] initWithX:hideP.x y:hideP.y+1.0f];
		barObjects = [[NSMutableDictionary alloc] init];
		state = BAR_LOCK;
		visible = NO;
		// default background values
		backgroundWidth = DEFAULT_BACKGROUND_WIDTH;
		backgroundHeight = DEFAULT_BACKGROUND_HEIGHT;
		// initialize direction to be set towards the display point
		direction = [Point2D subtract:displayPosition :hidePosition];
		transitionSpeed = DEFAULT_TRANSITION_SPEED;
		buttonPressed = BUTTON_NONE;
	}
	return self;
}

-(void)updateBar:(float)deltaTime
{
	// the logic below has the bar slide to the appropriate location depending on state, and locks it once there.
	switch (state) 
	{
		case BAR_HIDE:
			[currentPosition updateWithVector2D:direction speed:transitionSpeed deltaT:deltaTime];
			if(fabs(displayPosition.y - currentPosition.y) > fabs(displayPosition.y - hidePosition.y))
			{
				[currentPosition setX:hidePosition.x y:hidePosition.y];
				visible = NO;
				[self setState:BAR_LOCK];
			}
			[self transitionUIObjects];
			break;
		case BAR_DISPLAY:
			visible = YES;
			[currentPosition updateWithVector2D:direction speed:transitionSpeed deltaT:deltaTime];
			if(fabs(hidePosition.y - currentPosition.y) >= fabs(hidePosition.y - displayPosition.y) &&
			   fabs(hidePosition.x - currentPosition.x) >= fabs(hidePosition.x - displayPosition.x))
			{
				[currentPosition setX:displayPosition.x y:displayPosition.y];
				[self setState:BAR_LOCK];
			}
			[self transitionUIObjects];
			break;
		default:
			break;
	}
	if(visible)
	{
		// if we're visible, then we want to update our UIObjects as well
		for(NSString *UIKey in barObjects)
			[[barObjects objectForKey:UIKey] updateUIObject:deltaTime];
	}
}
-(void)transitionUIObjects;
{
	for(NSString *UIKey in barObjects)
	{
		UIObject *o = [barObjects objectForKey:UIKey];
		[[o UIObjectPosition] setX:currentPosition.x + o.UIObjectRelativePosition.x y:currentPosition.y + o.UIObjectRelativePosition.y];
	}
}
-(void)resetButtonPressed
{
	buttonPressed = BUTTON_NONE;
}
-(BOOL)barIsTouched:(CGPoint)touchPosition;
{
	CGRect controlBounds = CGRectMake(currentPosition.x, currentPosition.y, 
									  DEFAULT_BACKGROUND_WIDTH, DEFAULT_BACKGROUND_HEIGHT);
	
	if(CGRectContainsPoint(controlBounds, touchPosition))
		return YES;
	return NO;
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	// check all UIObjects for touch events and react accordingly
	for(NSString *UIKey in barObjects)
	{
		if([[barObjects objectForKey:UIKey] respondToTouchAt:touchPosition])
			return YES;
	}
	return NO;
}
-(void)setState:(uint)s
{
	// set our state and adjust direction
	Vector2D *newVec = nil;
	switch (s) 
	{
		case BAR_HIDE:
			newVec = [Point2D subtract:hidePosition :displayPosition];
			[direction setX:newVec.x y:newVec.y];
			break;
		case BAR_DISPLAY:
			newVec = [Point2D subtract:displayPosition :hidePosition];
			[direction setX:newVec.x y:newVec.y];
			break;
		default:
			break;
	}
	if(newVec)
		[newVec dealloc];
	state = s;
}
-(void)drawBar
{
	if(visible)
	{
		// draw background
		[background renderAtPoint:CGPointMake(currentPosition.x,currentPosition.y) centerOfImage:NO];
		
		// draw all UIObjects
		for(NSString *UIKey in barObjects)
			[[barObjects objectForKey:UIKey] drawUIObject];
	}
}
-(void)cashHasChanged:(uint)newCashAmount
{
	// do nothing!
}
-(void)hideBar
{
	visible = NO;
	[currentPosition setX:hidePosition.x y:hidePosition.y];
}

-(void)dealloc
{
	[currentPosition dealloc];
	[hidePosition dealloc];
	[displayPosition dealloc];
	[direction dealloc];
	[background release];
	for(NSString *UIKey in barObjects)
		[[barObjects objectForKey:UIKey] release];
	[barObjects removeAllObjects];
	[barObjects release];
	[super dealloc];
}

@end
