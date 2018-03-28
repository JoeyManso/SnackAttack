//
//  Math.h
//  towerDefense
//
//  Created by Joey Manso on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point2D.h"

#pragma mark -
#pragma mark Macros

// Macro which returns a random number between 0 and 1
#define RANDOM_0_TO_1() ((float)arc4random() / (float)0x100000000)
//#define RANDOM_0_TO_1()  ((random() / (GLfloat)0x7fffffff))

// Macro which returns a random value between -1 and 1
#define RANDOM_MINUS_1_TO_1() ((RANDOM_0_TO_1() * 2.0f) - 1.0f)
//#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff)-1.0f)
#pragma mark -
#pragma mark Types

@interface Math : NSObject 
{
}

// static methods
+(float)convertToRadians:(float)degrees;
+(float)convertToDegrees:(float)radians;
+(float)distance:(Point2D*)p1 :(Point2D*)p2;
+(float)CGdistance:(Point2D*)p1 :(CGPoint)p2;

@end
