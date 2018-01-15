//
//  Point2D.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Point2D.h"

@implementation Point2D

@synthesize x;
@synthesize y;

-(id)initWithX:(float)p_x y:(float)p_y
{
	if(self = [super init])
	{
		x = p_x;
		y = p_y;
	}
	return self;
}

-(void)setX:(float)p_x y:(float)p_y
{
	x = p_x;
	y = p_y;
}
-(void)updateWithVector2D:(Vector2D*)v speed:(float)s deltaT:(float)deltaT
{
	x += v.x * s * deltaT;
	y += v.y * s * deltaT;
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

+(Vector2D*)subtract:(Point2D*)p1 :(Point2D*)p2
{
	return [[Vector2D alloc] initWithX:p1.x-p2.x y:p1.y-p2.y];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[Point2D alloc] initWithX:x y:y];
}

@end
