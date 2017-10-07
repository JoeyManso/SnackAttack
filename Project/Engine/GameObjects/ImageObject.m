//
//  GameObject.m
//  towerDefense
//
//  Created by Joey Manso on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageObject.h"

@implementation ImageObject

@synthesize objectImage;

-(id)init
{
	return [self initWithName:nil position:nil image:nil];
}
-(id)initWithName:(NSString*)n position:(Point2D*)p image:(Image*)i
{
	// make sure we initialize the super class
	if (self = [super initWithName:n position:p])
	{
	    objectImage = i;
		objectAlpha = 1.0f;
		[objectImage retain];
	}
	return self;
}
-(void)setObjectScale:(float)s
{
	if(objectImage)
		[objectImage setScale:s];
	[super setObjectScale:s];
}
-(BOOL)isTouchedAtPoint:(CGPoint)p
{
	if(CGRectContainsPoint([self getObjectHitBox], p))
		return YES;
	return NO;
}
-(CGRect)getObjectHitBox
{
	return CGRectMake(objectPosition.x - (([objectImage imageWidth] * objectScale) * 0.5f), 
					  objectPosition.y - (([objectImage imageHeight] * objectScale) * 0.5f), 
					  [objectImage imageWidth] * objectScale, 
					  [objectImage imageHeight] * objectScale);
}
-(int)update:(float)deltaT
{
	return [super update:deltaT];
}
-(int)draw
{
	if(objectImage)
		[objectImage renderAtPoint:CGPointMake(objectPosition.x,objectPosition.y) rotationAngle:objectRotationAngle centerOfImage:YES alpha:objectAlpha];
	
	return [super draw];
}

@end
