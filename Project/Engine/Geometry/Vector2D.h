//
//  Vector2D.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Point2D;

@interface Vector2D : NSObject 
{
	float x;
	float y;
	float length;
}

@property(nonatomic,readonly)float x;
@property(nonatomic,readonly)float y;
@property(nonatomic,readonly)float length;

-(id)initWithX:(float)vecX y:(float)vecY;

-(void)setX:(float)vecX y:(float)vecY;
-(void)normalize;
-(float)dot:(Vector2D*)w;
-(float)cross:(Vector2D*)w;

-(void)add:(Vector2D*)v;
-(void)subtract:(Vector2D*)v;
-(void)multiply:(float)s;

-(void)setToPointSubtraction:(Point2D*)p1 :(Point2D*)p2;

// static methods
+(float)dot:(Vector2D*)v :(Vector2D*)w;
+(Vector2D*)add:(Vector2D*)v :(Vector2D*)w;
+(Vector2D*)subtract:(Vector2D*)v :(Vector2D*)w;
+(Vector2D*)multiply:(Vector2D*)v :(float)s;

@end
