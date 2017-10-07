//
//  Vector2D.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Vector2D.h"
#import "Point2D.h"

@implementation Vector2D

@synthesize x;
@synthesize y;
@synthesize length;

-(id)init
{
	return [self initWithX:0.0f y:0.0f];
}
-(id)initWithX:(float)vecX y:(float)vecY
{
	if(self = [super init])
	{
		x = vecX;
		y = vecY;
		[self normalize];
	}
	return self;
}

-(void)setX:(float)vecX y:(float)vecY
{
	x = vecX;
	y = vecY;
	[self normalize];

}
-(void)normalize
{
	length = sqrt(x*x + y*y);
	if(length != 0)
	{
		x *= 1.0f/length;
		y *= 1.0f/length;
	}
}
-(float)dot:(Vector2D*)w
{
	return (w.x * x) + (w.y * y);
}

-(float)cross:(Vector2D*)w
{
	return x*w.y - y*w.x;
}

-(void)add:(Vector2D*)v
{
	x += v.x;
	y += v.y;
}
-(void)subtract:(Vector2D*)v
{
	x -= v.x;
	y -= v.y;
}
-(void)multiply:(float)s
{
	x *= s;
	y *= s;
}
-(void)setToPointSubtraction:(Point2D*)p1 :(Point2D*)p2
{
	x = p1.x-p2.x;
	y = p1.y-p2.y;
}

// static methods
+(float)dot:(Vector2D*)v :(Vector2D*)w
{
	return [v dot:w];
}
+(Vector2D*)add:(Vector2D*)v :(Vector2D*)w
{
	return [[Vector2D alloc] initWithX:v.x+w.x y:v.y+w.y];
}
+(Vector2D*)subtract:(Vector2D*)v :(Vector2D*)w
{
	return [[Vector2D alloc] initWithX:v.x-w.x y:v.y-w.y];
}
+(Vector2D*)multiply:(Vector2D*)v :(float)s;
{
	return [[Vector2D alloc] initWithX:v.x * s y:v.y * s];
}

@end
