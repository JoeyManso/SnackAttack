//
//  BaseView.h
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseView : NSObject 
{	
	CGRect screenBounds;
    CGFloat screenScale;
    CGSize screenSize;
	uint viewState;
	float viewAlpha;
	NSString *nextViewKey;
    float viewFadeSpeed;
}

@property(nonatomic, readonly)CGRect screenBounds;
@property(nonatomic, readonly)CGFloat screenScale;
@property(nonatomic, readonly)CGSize screenSize;
@property (nonatomic, assign)uint viewState;
@property (nonatomic, assign)float viewAlpha;

-(void)updateView:(float)deltaTime;
-(void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;
-(void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;
-(void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view;

-(void)drawView;

@end
