//
//  AnimationObject.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AnimationObject.h"

// for our private methods
@interface AnimationObject ()

@end

@implementation AnimationObject

@synthesize aniCurrent;

-(id)init
{
	return [self initWithName:nil position:nil];
}
-(id)initWithName:(NSString*)n position:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	// make sure we initialize the super class
	if (self = [super initWithName:n position:p])
	{
		spriteSheet = ss;
		// reference to current animation, the actual animations need to be managed and initialized by the sub classes
	    aniCurrent = nil;
	}
	return self;
}

-(void)setAni:(Animation*)ani row:(int)row numFrames:(int)frames
{
	[self setAni:ani row:row numFrames:frames delay:0.16f];
}
-(void)setAni:(Animation*)ani row:(int)row numFrames:(int)frames delay:(float)delay
{
	for(int index=0; index<frames; index++)
	{
		[ani addFrameWithImage:[spriteSheet getSpriteAtX:index y:row] delay:delay];
	}
	[ani setRunning:YES];
	[ani setRepeat:YES];
}
-(BOOL)isTouchedAtPoint:(CGPoint)p
{
	if(CGRectContainsPoint([self getObjectHitBox], p))
		return YES;
	return NO;
}
-(CGRect)getObjectHitBox
{
	return CGRectMake(objectPosition.x - (([spriteSheet spriteWidth] * objectScale) * 0.5f), 
					  objectPosition.y - (([spriteSheet spriteHeight] * objectScale) * 0.5f), 
					  [spriteSheet spriteWidth] * objectScale, 
					  [spriteSheet spriteHeight] * objectScale);
}
-(int)update:(float)deltaT
{
	[aniCurrent update:deltaT];
	return [super update:deltaT];
}
-(int)draw
{
	[aniCurrent setScale:objectScale];
	[aniCurrent setRotationAngle:objectRotationAngle];
	[aniCurrent renderAtPoint:CGPointMake(objectPosition.x,objectPosition.y)];
	
	return [super draw];
}

@end
