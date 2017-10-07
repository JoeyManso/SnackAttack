//
//  Math.m
//  towerDefense
//
//  Created by Joey Manso on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Math.h"

@implementation Math

+(float)convertToRadians:(float)degrees
{
	return degrees * (M_PI/180.0f);
}
+(float)convertToDegrees:(float)radians
{
	return radians * (180.0f/M_PI);
}
+(float)distance:(Point2D*)p1 :(Point2D*)p2
{
	float d1 = p2.x - p1.x;
	float d2 = p2.y - p1.y;
	return sqrt(d1*d1 + d2*d2);
}
+(float)CGdistance:(Point2D*)p1 :(CGPoint)p2
{
	float d1 = p2.x - p1.x;
	float d2 = p2.y - p1.y;
	return sqrt(d1*d1 + d2*d2);
}

@end
