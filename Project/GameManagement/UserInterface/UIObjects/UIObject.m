//
//  UIObject.m
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIObject.h"

@implementation UIObject

@synthesize UIObjectScale;
@synthesize UIObjectPosition;
@synthesize UIObjectRelativePosition;

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super init])
	{
		UIObjectPosition = p;
		UIObjectRelativePosition = [[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y];
		[self setUIObjectScale:1.0f];
		
		animating = NO;
		shouldAnimate = YES;
		animationFullDuration = 0.5f;
		animationHalfDuration = animationFullDuration * 0.5f;
		animationCurrentTime = animationTimeRatio = 0.0f;		
	}
	return self;
}
-(void)setUIObjectScale:(float)s
{
	if(!animating)
	{
		baseScale = s;
		deltaScale = 0.3 * s;
	}
	
	UIObjectScale = s;
}
-(void)playScaleAnimation
{
	if(shouldAnimate)
	{
		animating = YES;
		playScaleAnimation = YES;
	}
}
-(BOOL)respondToTouchAt:(CGPoint)touchPosition
{
	return NO;
}
-(void)selectUIObject
{
}
-(void)updateUIObject:(float)deltaTime
{
	if(animating)
	{
		if(playScaleAnimation)
		{
			[self setUIObjectScale:baseScale+(animationTimeRatio * deltaScale)];
		}
		
		if(animationCurrentTime < animationHalfDuration)
			animationTimeRatio = animationCurrentTime/animationHalfDuration;
		else if(animationCurrentTime < animationFullDuration)
			animationTimeRatio = (animationFullDuration - 2*(animationCurrentTime - animationHalfDuration))/animationFullDuration;
		else // animation finished
		{
			animationTimeRatio = animationCurrentTime = 0.0f;
			animating = playScaleAnimation = NO;
			return;
		}
		
		animationCurrentTime += deltaTime;
		
	}
}
-(void)drawUIObject
{
}
-(void)drawUIObjectAtPoint:(Point2D*)p
{
}
-(void)drawUIObjectAtCGPoint:(CGPoint)p
{
}
-(void)dealloc
{
	[UIObjectPosition dealloc];
	[UIObjectRelativePosition dealloc];
	[super dealloc];
}

@end
