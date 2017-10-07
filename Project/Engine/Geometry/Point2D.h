//
//  Point2D.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"

@interface Point2D : NSObject 
{
	float x;
	float y;
}
@property(nonatomic)float x;
@property(nonatomic)float y;

-(id)initWithX:(float)p_x y:(float)p_y;

-(void)setX:(float)p_x y:(float)p_y;
-(void)updateWithVector2D:(Vector2D*)v speed:(float)s deltaT:(float)deltaT;

-(void)add:(Vector2D*)v;
-(void)subtract:(Vector2D*)v;

+(Vector2D*)subtract:(Point2D*)p1 :(Point2D*)p2;

@end
