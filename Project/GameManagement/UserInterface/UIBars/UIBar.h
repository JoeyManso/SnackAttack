//
//  UIBar.h
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point2D.h"
#import "Image.h"

// for bars
enum
{
	BAR_DISPLAY,
	BAR_HIDE,
	BAR_LOCK
};

// for buttons
enum
{
	BUTTON_NONE,
	BUTTON_TOWER,
	BUTTON_CONFIRM,
	BUTTON_CANCEL,
	BUTTON_START,
	BUTTON_RESUME,
	BUTTON_PAUSE,
	BUTTON_MENU,
	BUTTON_UPGRADE,
	BUTTON_SELL,
	BUTTON_ROUND,
    BUTTON_SPEEDDOWN,
    BUTTON_SPEEDUP
};

@interface UIBar : NSObject 
{
	Point2D *currentPosition;
	Point2D *displayPosition;
	Point2D *hidePosition;
	Vector2D *direction;
	float transitionSpeed;
	NSMutableDictionary *barObjects; // UIObjects contained within this UIBar that may or may not be interacted with
	Image *background;
	float backgroundWidth;
	float backgroundHeight;
	BOOL visible;
	uint state;
	uint buttonPressed; // enum variable for button events
}
@property(nonatomic, readonly)Point2D *currentPosition;
@property(nonatomic, readonly)Point2D *displayPosition;
@property(nonatomic, readonly)Point2D *hidePosition;
@property(nonatomic)uint state;
@property(nonatomic, readonly)BOOL visible;
@property(nonatomic, readonly)float backgroundWidth;
@property(nonatomic, readonly)float backgroundHeight;
@property(nonatomic)uint buttonPressed; // returns which button was pressed, if any

-(id)initWithBackground:(Image*)i;
-(id)initWithDisplayPos:(Point2D*)dispP hidePos:(Point2D*)hideP imageRef:(Image*)i;
-(BOOL)barIsTouched:(CGPoint)touchPosition;
-(BOOL)touchEvent:(CGPoint)touchPosition;
-(void)resetButtonPressed;
-(void)updateBar:(float)deltaTime;
-(void)drawBar;
-(void)hideBar;
-(void)cashHasChanged:(uint)newCashAmount;

-(void)transitionUIObjects; // moves UIObjects when the bar moves

@end
