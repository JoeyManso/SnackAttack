//
//  BaseView.m
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

@synthesize screenBounds;
@synthesize screenScale;
@synthesize screenSize;
@synthesize viewState;
@synthesize viewAlpha;

-(id)init
{
	if(self = [super init])
	{
		screenBounds = [[UIScreen mainScreen] bounds];
        screenScale = [[UIScreen mainScreen] scale];
        screenSize = CGSizeMake(screenBounds.size.width * screenScale,
                                screenBounds.size.height * screenScale);
		viewState = 0;
		viewAlpha = 1.0f;
		nextViewKey = nil;
		viewFadeSpeed = 1.0f;
	}
	return self;
}

-(void)updateView:(float)deltaTime{};
-(void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view{}
-(void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view{}
-(void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view{}

-(void)drawView{}	

@end
