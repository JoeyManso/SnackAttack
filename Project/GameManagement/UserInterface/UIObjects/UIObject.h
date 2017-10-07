//
//  UIObject.h
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point2D.h"

@interface UIObject : NSObject 
{
	float UIObjectScale;
	Point2D *UIObjectPosition;
	Point2D *UIObjectRelativePosition;
	
	@protected
	BOOL shouldAnimate;
	
	@private
	// used for reference when animating
	float baseScale; 
	float deltaScale;
	
	BOOL animating; // flag if we are currently animating
	
	float animationFullDuration;
	float animationHalfDuration;
	float animationCurrentTime;
	float animationTimeRatio; // how far along animation should display
	
	BOOL playScaleAnimation;
}
@property(nonatomic)float UIObjectScale;
@property(nonatomic, readonly)Point2D *UIObjectPosition;
@property(nonatomic, readonly)Point2D *UIObjectRelativePosition;

-(id)initWithPosition:(Point2D*)p;
-(BOOL)respondToTouchAt:(CGPoint)touchPosition;
-(void)updateUIObject:(float)deltaTime;
-(void)drawUIObject;
-(void)drawUIObjectAtPoint:(Point2D*)p;
-(void)drawUIObjectAtCGPoint:(CGPoint)p;
-(void)playScaleAnimation;

@end
